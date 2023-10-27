#!/bin/bash

# 检测执行是否成功
function check_success() {
    if [ $? -gt 0  ];then
        echo "retcode != 0, check failed!"
        exit 1
    fi 
}

# root用户检测
function root_need() {
    if [[ $EUID -ne 0 ]]; then
        echo "Error: This script must be run as root!" 1>&2
        exit 1
    fi
}

# 基础环境安装
function pre_install_env() {
    # gcc已安装检测
    gcc_version="13.2.0"
    gcc_installed=`gcc -v 2>&1 | grep version | awk '{print(match($0, "'$gcc_version'")>0)}'`
    if [ -z $gcc_installed ] || [ $gcc_installed == "0" ]; then
        yum install -y gcc-c++ gcc libtool
    fi

    # openssl已安装检测
    openssl_version="1.1.1w"
    openssl_installed=`openssl version 2>&1 | awk '{print(match($0, "'$openssl_version'")>0)}'`
    if [ -z $openssl_installed ] || [ $openssl_installed == "0" ]; then
        yum install -y openssl-devel
    fi


    yum install -y curl-devel mysql-devel zlib-devel screen wget git fuse fuse-devel
    yum install -y bzip2 bzip2-devel zip unzip
    yum install -y make automake kernel-devel
    yum install -y ncurses-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel python-devel
    yum install -y readline-devel texinfo bc
    yum install -y telnet psmisc lsof openssh-server openssh-clients openssh
}

# 安装cmake
function install_cmake() {
    app_name="cmake"
    app_version="3.10.0"
    download_path="https://cmake.org/files/v3.10/"$app_name"-"$app_version".tar.gz"

    # 已安装检测
    is_installed=`cmake --version 2>&1 | grep version | awk '{print (match($0, '$app_version')>0)}'`
    if [ -n $is_installed ] && [ $is_installed == "1" ]; then
      echo $app_name"-"$app_version" is installed, skip..."
      return 0
    fi

    wget $download_path --no-check-certificate && \
    tar -zxvf $app_name"-"$app_version".tar.gz" && \
    cd $app_name"-"$app_version && \
    ./bootstrap && gmake -j8 && make install && \
    cd ../ && rm -rf $app_name"-"$app_version*
    check_success
}

# 安装gnu相关工具
function install_gnu_tool() {
    # 安装zlib
    app_name="zlib"
    app_version="1.3"
    download_path="http://www.zlib.net/"$app_name"-"$app_version".tar.gz"
    if [ ! -d /usr/local/$app_name-$app_version ]; then
        wget $download_path --no-check-certificate && \
        tar -xvf $app_name"-"$app_version".tar.gz" && \
        cd $app_name"-"$app_version && \
        mkdir build && cd build && \
        ../configure --prefix=/usr/local/$app_name"-"$app_version && \
        make -j8 && make install && \
        ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
        cd ../../ && rm -rf $app_name"-"$app_version*
        check_success
    else
        echo $app_name"-"$app_version" is installed, skip..."
    fi

    # 安装gmp
    app_name="gmp"
    app_version="6.3.0"
    download_path="https://ftp.gnu.org/gnu/"$app_name"/"$app_name"-"$app_version".tar.gz"
    if [ ! -d /usr/local/$app_name-$app_version ]; then
        wget $download_path --no-check-certificate && \
        tar -xvf $app_name"-"$app_version".tar.gz" && \
        cd $app_name"-"$app_version && \
        mkdir build && cd build && \
        ../configure --prefix=/usr/local/$app_name"-"$app_version && \
        make -j8 && make install && \
        ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
        echo "/usr/local/"$app_name"/lib" >> /etc/ld.so.conf.d/gnu.conf && \
        ldconfig && \
        cd ../../ && rm -rf $app_name"-"$app_version*
        check_success
    else
        echo $app_name"-"$app_version" is installed, skip..."
    fi

    # 安装mpfr
    app_name="mpfr"
    app_version="4.2.1"
    download_path="https://ftp.gnu.org/gnu/"$app_name"/"$app_name"-"$app_version".tar.gz"
    if [ ! -d /usr/local/$app_name-$app_version ]; then
        wget $download_path --no-check-certificate && \
        tar -xvf $app_name"-"$app_version".tar.gz" && \
        cd $app_name"-"$app_version && \
        mkdir build && cd build && \
        ../configure --prefix=/usr/local/$app_name"-"$app_version --with-gmp=/usr/local/gmp && \
        make -j8 && make install && \
        ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
        echo "/usr/local/"$app_name"/lib" >> /etc/ld.so.conf.d/gnu.conf && \
        ldconfig && \
        cd ../../ && rm -rf $app_name"-"$app_version*
        check_success
    else
        echo $app_name"-"$app_version" is installed, skip..."
    fi

    # 安装mpc
    app_name="mpc"
    app_version="1.3.1"
    download_path="https://ftp.gnu.org/gnu/"$app_name"/"$app_name"-"$app_version".tar.gz"
    if [ ! -d /usr/local/$app_name-$app_version ]; then
        wget $download_path --no-check-certificate && \
        tar -xvf $app_name"-"$app_version".tar.gz" && \
        cd $app_name"-"$app_version && \
        mkdir build && cd build && \
        ../configure --prefix=/usr/local/$app_name"-"$app_version --with-gmp=/usr/local/gmp --with-mpfr=/usr/local/mpfr && \
        make -j8 && make install && \
        ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
        echo "/usr/local/"$app_name"/lib" >> /etc/ld.so.conf.d/gnu.conf && \
        ldconfig && \
        cd ../../ && rm -rf $app_name"-"$app_version*
        check_success
    else
        echo $app_name"-"$app_version" is installed, skip..."
    fi

    # 安装readline
    app_name="readline"
    app_version="8.2"
    download_path="ftp://ftp.gnu.org/gnu/"$app_name"/"$app_name"-"$app_version".tar.gz"
    if [ ! -d /usr/local/$app_name-$app_version ]; then
        wget $download_path --no-check-certificate && \
        tar -xvf $app_name"-"$app_version".tar.gz" && \
        cd $app_name"-"$app_version && \
        mkdir build && cd build && \
        ../configure --prefix=/usr/local/$app_name"-"$app_version && \
        make -j8 && make install && \
        ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
        echo "/usr/local/"$app_name"/lib" >> /etc/ld.so.conf.d/gnu.conf && \
        rm -f /usr/lib64/libreadline.so
        check_success

        if [ -d /usr/include/$app_name ]; then
            mv -f /usr/include/$app_name /usr/include/$app_name.back
            check_success
        fi

        ln -sfn /usr/local/$app_name/include/$app_name /usr/include/$app_name && \
        ldconfig && \
        cd ../../ && rm -rf $app_name"-"$app_version*
        check_success
    else
        echo $app_name"-"$app_version" is installed, skip..."
    fi
}

# 安装gnu gcc
function install_gcc() {
    app_name="gcc"
    app_version="13.2.0"
    download_path="https://ftp.gnu.org/gnu/"$app_name"/"$app_name"-"$app_version"/"$app_name"-"$app_version".tar.xz"

    # 已安装检测
    if [ -d /usr/local/$app_name-$app_version ]; then
        echo $app_name"-"$app_version" is installed, skip..."
        return 0
    fi

    # 下载并编译
    wget $download_path --no-check-certificate && \
    tar -xvf $app_name"-"$app_version".tar.xz" && \
    cd $app_name"-"$app_version && \
    mkdir build && cd build && \
    ../configure --prefix=/usr/local/$app_name"-"$app_version --enable-bootstrap --disable-multilib --enable-bootstrap --enable-default-pie \
        --enable-default-ssp --disable-fixincludes --enable-languages=c,c++,go --with-zlib=/usr/local/zlib \
        --with-gmp=/usr/local/gmp --with-mpfr=/usr/local/mpfr --with-mpc=/usr/local/mpc && \
    make -j8
    check_success

    # 卸载自带的gcc
    yum remove gcc libtool -y
    rpm -e --nodeps libgcc

    # 开始安装
    make install && \
    ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
    mv /usr/local/$app_name/bin/go /usr/local/$app_name/bin/gcc-go && \
    mv /usr/local/$app_name/bin/gofmt /usr/local/$app_name/bin/gcc-gofmt && \
    echo "/usr/local/"$app_name"/lib64" >> /etc/ld.so.conf.d/gnu.conf && \
    echo "export PATH=/usr/local/"$app_name"/bin:\$PATH" >> /etc/profile && \
    mv -f /usr/local/$app_name/lib64/*gdb.py /usr/share/gdb/auto-load/usr/lib64/ && \
    ln -sfn /usr/local/$app_name/include /usr/include/$app_name && \
    ln -sfn /usr/include/$app_name/bin/$app_name /usr/bin/$app_name && \
    rm -f /usr/lib64/libstdc++.so.6 && \
    source /etc/profile && ldconfig && \
    cd ../../ && rm -rf $app_name"-"$app_version*
    check_success
}

# 安装gdb
function install_gdb() {
    app_name="gdb"
    app_version="13.2"
    download_path="https://ftp.gnu.org/gnu/"$app_name"/"$app_name"-"$app_version".tar.gz"

    # 已安装检测
    if [ -d /usr/local/$app_name-$app_version ]; then
        echo $app_name"-"$app_version" is installed, skip..."
        return 0
    fi

    # 卸载自带的gdb
    yum remove gdb -y
    
    if [ ! -d /data/thirdparty ]
    then
        mkdir -p /data/thirdparty
    fi

    if [ ! -d /etc/gdb ]
    then
        mkdir /etc/gdb
    fi
    
    # 安装beauty print
    if [ ! -d /data/thirdparty/python ]
    then 
        svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python && \
        mv -f python /data/thirdparty
        check_success
    fi

    # 拷贝gdbinit
    if [ ! -f /etc/gdb/gdbinit ]
    then
        wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/gdbinit && \
        mv -f gdbinit /etc/gdb/gdbinit
        check_success
    fi

    # 安装readline
    
    # 安装gdb
    wget $download_path --no-check-certificate && \
    tar -xvf $app_name"-"$app_version".tar.gz" && \
    cd $app_name"-"$app_version && \
    mkdir build && cd build && \
    ../configure --prefix=/usr/local/$app_name"-"$app_version --enable-tui=yes --with-system-gdbinit=/etc/gdb/gdbinit \
        --with-libpython-prefix=/usr/local/python3 --with-system-readline=/usr/local/readline --with-libgmp-prefix=/usr/local/gmp \
        --with-libmpc-prefix=/usr/local/mpc --with-libmpfr-prefix=/usr/local/mpfr && \
    make -j8 && make install && \
    ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
    echo "export PATH=/usr/local/"$app_name"/bin:\$PATH" >> /etc/profile && \
    source /etc/profile && \
    cd ../../ && rm -rf $app_name"-"$app_version*
    check_success
}

# 安装golang
function install_go() {
    app_name="go"
    app_version="1.20.10"
    download_path="https://go.dev/dl/"$app_name$app_version".linux-amd64.tar.gz"

    # 已安装检测
    if [ -d /usr/local/$app_name-$app_version ]; then
      echo $app_name"-"$app_version" is installed, skip..."
      return 0
    fi

    wget $download_path --no-check-certificate && mkdir temp_go && \
    tar -C ./temp_go -xvf $app_name$app_version".linux-amd64.tar.gz" && \
    mv -f ./temp_go/$app_name /usr/local/$app_name"-"$app_version
    ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
    echo "export PATH=/usr/local/"$app_name"/bin:\$PATH" >> /etc/profile && \
    echo "export GOROOT=/usr/local/"$app_name >> /etc/profile && \
    source /etc/profile && \
    sed -i 's/Defaults.*secure_path.*/&:\/usr\/local\/go\/bin/g' /etc/sudoers && \
    rm -rf $app_name$app_version* temp_go
    check_success
}

# 安装svn
function install_svn() {
    # 卸载原生svn
    yum remove -y svn

    # 安装apr
    app_name="apr"
    app_version="1.7.4"
    download_path="https://dlcdn.apache.org/apr/"$app_name"-"$app_version".tar.gz"
    if [ ! -d /usr/local/$app_name-$app_version ]; then
        wget $download_path --no-check-certificate && \
        tar -xvf $app_name"-"$app_version".tar.gz" && \
        cd $app_name"-"$app_version && \
        mkdir build_dir && cd build_dir && \
        ../configure --prefix=/usr/local/$app_name"-"$app_version && \
        make -j8 && make install && \
        ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
        cd ../../ && rm -rf $app_name"-"$app_version*
        check_success
    else
        echo $app_name"-"$app_version" is installed, skip..."
    fi

    # 安装apr-util
    app_name="apr-util"
    app_version="1.6.3"
    download_path="https://dlcdn.apache.org/apr/"$app_name"-"$app_version".tar.gz"
    if [ ! -d /usr/local/$app_name-$app_version ]; then
        wget $download_path --no-check-certificate && \
        tar -xvf $app_name"-"$app_version".tar.gz" && \
        cd $app_name"-"$app_version && \
        mkdir build_dir && cd build_dir && \
        ../configure --prefix=/usr/local/$app_name"-"$app_version --with-apr=/usr/local/apr && \
        make -j8 && make install && \
        ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
        cd ../../ && rm -rf $app_name"-"$app_version*
        check_success
    else
        echo $app_name"-"$app_version" is installed, skip..."
    fi

    # 卸载自带的sqlite
    rpm -e --nodeps sqlite

    # 安装sqlite3
    app_name="sqlite3"
    app_version="3.43.2"
    download_path="https://www.sqlite.org/2023/sqlite-autoconf-3430200.tar.gz"
    if [ ! -d /usr/local/$app_name-$app_version ]; then
        wget $download_path --no-check-certificate && \
        tar -xvf "sqlite-autoconf-3430200.tar.gz" && \
        cd "sqlite-autoconf-3430200" && \
        mkdir build && cd build && \
        ../configure --prefix=/usr/local/$app_name"-"$app_version && \
        make -j8 && make install && \
        ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
        echo "export PATH=/usr/local/"$app_name"/bin:\$PATH" >> /etc/profile && \
        echo "/usr/local/"$app_name"/lib" >> /etc/ld.so.conf.d/$app_name.conf && \
        source /etc/profile && ldconfig && \
        cd ../../ && rm -rf $app_name"-*"
        check_success
    else
        echo $app_name"-"$app_version" is installed, skip..."
    fi

    # 安装scons
    app_name="scons"
    app_version="2.3.0"
    download_path="https://cfhcable.dl.sourceforge.net/project/"$app_name"/"$app_name"/"$app_version"/"$app_name"-"$app_version".tar.gz"
    is_installed=`$app_name -v 2>&1 | grep version | awk '{print (match($0, '$app_version')>0)}'`
    if [ -n $is_installed ] && [ $is_installed == "1" ]; then
        echo $app_name"-"$app_version" is installed, skip..."
    else
        wget $download_path --no-check-certificate && \
        tar -xvf $app_name"-"$app_version".tar.gz" && \
        cd $app_name"-"$app_version && \
        python2 setup.py install && \
        cd ../ && rm -rf $app_name"-"$app_version*
        check_success
    fi

    # 安裝serf
    app_name="serf"
    app_version="1.3.10"
    download_path="https://www.apache.org/dist/"$app_name"/"$app_name"-"$app_version".tar.bz2"
    if [ ! -d /usr/local/$app_name-$app_version ]; then
        wget $download_path --no-check-certificate && \
        tar -xvf $app_name"-"$app_version".tar.bz2" && \
        cd $app_name"-"$app_version && \
        scons PREFIX=/usr/local/$app_name"-"$app_version APR=/usr/local/apr APU=/usr/local/apr-util && \
        scons install && \
        ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
        echo "/usr/local/"$app_name"/lib" >> /etc/ld.so.conf.d/$app_name.conf && \
        ldconfig && \
        cd ../ && rm -rf $app_name"-"$app_version*
        check_success
    else
        echo $app_name"-"$app_version" is installed, skip..."
    fi

    # 安裝svn
    app_name="subversion"
    app_version="1.14.2"
    download_path="https://dlcdn.apache.org/"$app_name"/"$app_name"-"$app_version".tar.gz"
    if [ ! -d /usr/local/$app_name-$app_version ]; then
        wget $download_path --no-check-certificate && \
        tar -xvf $app_name"-"$app_version".tar.gz" && \
        cd $app_name"-"$app_version && \
        mkdir build_dir && cd build_dir && \
        ../configure --prefix=/usr/local/$app_name"-"$app_version --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util \
            --with-sqlite=/usr/local/sqlite3 --with-zlib=/usr/local/zlib --with-serf=/usr/local/serf --with-lz4=internal --with-utf8proc=internal && \
        make -j8 && make install && \
        ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
        echo "export PATH=/usr/local/"$app_name"/bin:\$PATH" >> /etc/profile
        source /etc/profile && \
        cd ../../ && rm -rf $app_name"-"$app_version*
        check_success
    else
        echo $app_name"-"$app_version" is installed, skip..."
    fi
}

# 安装python3
function install_python3() {
    app_name="python3"
    app_version="3.7.17"
    download_path="https://www.python.org/ftp/python/"$app_version"/Python-"$app_version".tgz"

    # 已安装检测
    if [ -d /usr/local/$app_name-$app_version ]; then
        echo $app_name"-"$app_version" is installed, skip..."
        return 0
    fi

    wget $download_path --no-check-certificate && \
    tar -xvf "Python-"$app_version".tgz" && \
    cd "Python-"$app_version && \
    mkdir build && cd build && \
    ../configure --prefix=/usr/local/$app_name"-"$app_version --enable-shared && \
    make -j8 && make install
    check_success

    # 修改自带python为back
    pypath=`which python`
    if [ $? -eq 0  ]
    then
        Sp=${pypath%/*}
        mv $pypath $Sp/python_bak
    fi

    ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
    echo "/usr/local/"$app_name"/lib" >> /etc/ld.so.conf.d/$app_name.conf && \
    echo "export PATH=/usr/local/"$app_name"/bin:\$PATH" >> /etc/profile && \
    ln -sfn /usr/local/"$app_name"/bin/$app_name /usr/bin/python && \
    source /etc/profile && ldconfig && \
    cd ../../ && rm -rf "Python-"$app_version*
    check_success

    # 更新yum
    wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/yum --no-check-certificate && \
    chmod 775 yum && mv -f ./yum /usr/bin/yum && \
    wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/urlgrabber-ext-down --no-check-certificate && \
	  chmod 775 urlgrabber-ext-down && mv -f ./urlgrabber-ext-down /usr/libexec/urlgrabber-ext-down
    check_success
}

# 安装nodejs
function install_nodejs() {
    app_name="node"
    app_version="v16.18.0"
    download_path="https://cdn.npmmirror.com/binaries/"$app_name"/"$app_version"/"$app_name"-"$app_version"-linux-x64.tar.gz"

    # 已安装检测
    if [ -d /usr/local/$app_name-$app_version ]; then
      echo $app_name"-"$app_version" is installed, skip..."
      return 0
    fi

    wget $download_path --no-check-certificate && \
    tar -xvf $app_name"-"$app_version"-linux-x64.tar.gz" && \
    mv $app_name"-"$app_version"-linux-x64" /usr/local/$app_name"-"$app_version && \
    ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
    echo "export NODE_HOME=/usr/local/"$app_name >> /etc/profile && \
    echo "export PATH=/usr/local/"$app_name"/bin:\$PATH" >> /etc/profile && \
    echo "export NODE_PATH=$NODE_HOME/lib/node_modules:\$PATH" >> /etc/profile && \
    source /etc/profile && \
    npm install -g yarn neovim && \
    rm -f $app_name"-"$app_version"*"
    check_success
}

# 安装neo vim
function install_nvim() {
    # 已安装检测
    if [ -f /usr/bin/nvim.appimage ]; then
        echo "nvim.appimage is installed, skip..."
        return 0
    fi

    # 卸载自带的vim
    yum remove -y vim

    pip3 install --upgrade pip && \
    pip3 install pynvim pygments neovim && \
    wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage --no-check-certificate && \
    chmod 777 nvim.appimage && \
    mv nvim.appimage /usr/bin/nvim.appimage && \
    rm -f /bin/vim /bin/vi && \
    ln -sfn /usr/bin/nvim.appimage /bin/vim && \
    ln -sfn /usr/bin/nvim.appimage /bin/vi && \
    npm i -g bash-language-server
    check_success
}

# 安装gnu global
function install_gtags(){
    app_name="global"
    app_version="6.6.10"
    download_path="https://ftp.gnu.org/pub/gnu/"$app_name"/"$app_name"-"$app_version".tar.gz"

    # 已安装检测
    if [ -d /usr/local/$app_name-$app_version ]; then
        echo $app_name"-"$app_version" is installed, skip..."
        return 0
    fi

    wget $download_path --no-check-certificate && \
    tar -xvf $app_name"-"$app_version".tar.gz" && \
    cd $app_name"-"$app_version && \
    mkdir build && cd build && \
    ../configure --prefix=/usr/local/$app_name"-"$app_version --with-sqlite3=/usr/local/sqlite3 && \
    make -j8 && make install && \
    ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
    echo "export PATH=/usr/local/"$app_name"/bin:\$PATH" >> /etc/profile && \
    source /etc/profile && \
    cd ../../ && rm -rf $app_name"-"$app_version*
    check_success
}



# 安装wsl的systemctl
function install_systemctl() {
    mv -f /usr/bin/systemctl /usr/bin/systemctl.old && \
    curl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py > /usr/bin/systemctl && \
    chmod +x /usr/bin/systemctl
    check_success
}

# 安装openssl
function install_openssl() {
    app_name="openssl"
    app_version="1.1.1w"
    download_path="https://www.openssl.org/source/"$app_name"-"$app_version".tar.gz"

    # 已安装检测
    if [ -d /usr/local/$app_name-$app_version ]; then
        echo $app_name"-"$app_version" is installed, skip..."
        return 0
    fi

    wget $download_path --no-check-certificate && \
    tar -xvf $app_name"-"$app_version".tar.gz" && \
    cd $app_name"-"$app_version && \
    mkdir build && cd build && \
    ../config --prefix=/usr/local/$app_name"-"$app_version && \
    make -j8 && make install
    check_success

    yum remove openssl openssl-devel -y

    ln -sfn /usr/local/$app_name"-"$app_version /usr/local/$app_name && \
    echo "export PATH=/usr/local/"$app_name"/bin:\$PATH" >> /etc/profile && \
    echo "/usr/local/"$app_name"/lib" >> /etc/ld.so.conf.d/$app_name.conf && \
    source /etc/profile && \
    cd ../../ && rm -rf $app_name"-"$app_version*
    check_success

}

# 安装nxx所需环境
function install_nxx_evn() {
    # 安装ctags
    app_name="ctags"
    if [ ! -d /usr/local/$app_name ]; then
        git clone https://github.com/universal-ctags/ctags.git $app_name && \
        cd $app_name && ./autogen.sh && \
        mkdir build && cd build && \
        ../configure --prefix=/usr/local/$app_name && \
        make -j8 && make install && \
        echo "export PATH=/usr/local/"$app_name"/bin:\$PATH" >> /etc/profile && \
        source /etc/profile && \
        cd ../../ && rm -rf $app_name*
        check_success
    else
        echo $app_name" is installed, skip..."
    fi
    
    # 设置个人链接库
    if [ -z `cat /etc/ld.so.conf | grep "/usr/local/lib"` ]; then
        echo "/usr/local/lib" >> /etc/ld.so.conf
        check_success
    fi

    #拷贝protoc xlua.so，librsa.a
    if [ ! -f /usr/local/bin/protoc ]; then
        wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/protoc --no-check-certificate && \
        chmod +x protoc && mv -f protoc /usr/local/bin/protoc
        check_success
    fi
    
    if [ ! -f /usr/local/lib/libxlua.so ]; then
        wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/libxlua.so --no-check-certificate && \
        mv -f libxlua.so /usr/local/lib/libxlua.so && ldconfig
        check_success
    fi
    
    if [ ! -f /usr/local/lib/librsa.a ]; then
        wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/librsa.a --no-check-certificate && \
        mv -f librsa.a /usr/local/lib/librsa.a && ldconfig
        check_success
    fi

    #安装consul
    if [ -z `consul -v 2>&1 | grep "Consul"` ]; then
        yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
        yum -y install consul && \
        mkdir -p /data/Consul/data && \
        mkdir -p /data/Consul/conf && \
        mkdir -p /data/Consul/logs
        check_success
    fi


    #安装redis
    if [ -z `redis-cli -v 2>&1 | grep "redis-cli "` ]; then
        wget https://download.redis.io/redis-stable.tar.gz && \
        tar -xzvf redis-stable.tar.gz && \
        cd redis-stable && \
        make -j8 && make install && \
        mkdir -p /data/Redis/conf && \
        cp redis.conf /data/Redis/conf/redis.conf && \
        cd ../ && rm -rf redis-stable*
        check_success
    fi
}

# 安装函数
function main() {
    echo "请使用root权限运行此脚本" && \
    root_need && \
    pre_install_env && \
    install_cmake && \
    install_gnu_tool && \
    install_gcc && \
    install_go && \
    install_svn && \
    install_gdb && \
    install_python3 && \
    install_nodejs && \
    install_nvim && \
    install_gtags && \
    install_systemctl && \
    install_openssl && \
    install_nxx_evn

    check_success
}

main
