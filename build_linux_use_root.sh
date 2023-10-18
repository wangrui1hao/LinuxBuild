#!/bin/bash

function root_need() {
    if [[ $EUID -ne 0 ]]; then
        echo "Error:This script must be run as root!" 1>&2
        exit 1
    fi
}

function pre_install_env() {
    yum install -y curl-devel
    yum install -y mysql-devel
    yum install -y zlib-devel
    yum install -y screen
    yum install -y git
    yum install -y wget
    yum install -y bzip2
    yum install -y fuse fuse-devel
    yum install -y zip unzip
    yum install -y libtool
    yum install -y gcc-c++ make automake gcc kernel-devel
    yum install -y bzip2-devel openssl-devel ncurses-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel python-devel
    yum install -y texinfo
    yum install -y bc
}

function install_cmake() {
    wget https://cmake.org/files/v3.10/cmake-3.10.0.tar.gz
    if [ $? -gt 0  ];then
        echo "cmake安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -zxvf cmake-3.10.0.tar.gz
    cd cmake-3.10.0
    ./bootstrap
    gmake -j8
    make install
    cd ../
    rm -rf cmake-3.10.0*
}

function install_nodejs() {
    wget https://cdn.npmmirror.com/binaries/node/v16.16.0/node-v16.16.0-linux-x64.tar.gz --no-check-certificate
    if [ $? -gt 0  ];then
        echo "nodejs安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -xvf node-v16.16.0-linux-x64.tar.gz
    mv node-v16.16.0-linux-x64 /usr/local/node.js
    ln -s /usr/local/node.js/bin/node /usr/bin/node
    ln -s /usr/local/node.js/bin/npm /usr/bin/npm
    npm install -g yarn
    npm install -g neovim
    echo "export NODE_HOME=/usr/local/node.js" >> /etc/profile
    echo "export PATH=/usr/local/node.js/bin:\$PATH" >> /etc/profile
    echo "export NODE_PATH=$NODE_HOME/lib/node_modules:\$PATH" >> /etc/profile
    source /etc/profile
    rm -f node-v16.16.0-linux-x64.tar.gz
}

function install_go() {
    wget https://dl.google.com/go/go1.16.2.linux-amd64.tar.gz
    if [ $? -gt 0  ];then
        echo "go安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -C /usr/local -xvf go1.16.2.linux-amd64.tar.gz
    echo "export PATH=/usr/local/go/bin:\$PATH" >> /etc/profile
    echo "export GOROOT=/usr/local/go" >> /etc/profile
    source /etc/profile
    sed -i 's/Defaults.*secure_path.*/&:\/usr\/local\/go\/bin/g' /etc/sudoers
    rm -rf go1.16.2.linux-amd64.tar.gz
}

function install_svn() {
    #卸载原生svn
    yum remove -y svn

    #安装apr
    wget https://dlcdn.apache.org//apr/apr-1.7.4.tar.gz --no-check-certificate
    if [ $? -gt 0  ];then
        echo "apr安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -xvf apr-1.7.4.tar.gz
    cd apr-1.7.4
    mkdir build_dir && cd build_dir
    ../configure --prefix=/usr/local/apr
    make -j8 && make install
    cd ../../
    rm -rf apr-1.7.4*

    #安装apr-util
    wget https://dlcdn.apache.org//apr/apr-util-1.6.3.tar.gz --no-check-certificate
    if [ $? -gt 0  ];then
        echo "apr-util安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -xvf apr-util-1.6.3.tar.gz
    cd apr-util-1.6.3
    mkdir build_dir && cd build_dir
    ../configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr
    make -j8 && make install
    cd ../../
    rm -rf apr-util-1.6.3*

    #安装sqlite3
    wget https://www.sqlite.org/2022/sqlite-autoconf-3390200.tar.gz --no-check-certificate
    if [ $? -gt 0  ];then
        echo "sqlite3安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -xvf sqlite-autoconf-3390200.tar.gz
    cd sqlite-autoconf-3390200
    mkdir build && cd build
    ../configure --prefix=/usr/local/sqlite
    make -j8 && make install
    cd ../../
    rm -rf sqlite-autoconf-3390200*

    #安裝zlib
    wget http://www.zlib.net/zlib-1.3.tar.gz --no-check-certificate
    if [ $? -gt 0  ];then
        echo "zlib安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -xvf zlib-1.3.tar.gz
    cd zlib-1.3
    mkdir build && cd build
    ../configure --prefix=/usr/local/zlib
    make -j8 && make install
    cd ../../
    rm -rf zlib-1.3*

    #安装scons
    wget https://cfhcable.dl.sourceforge.net/project/scons/scons/2.3.0/scons-2.3.0.tar.gz --no-check-certificate
    if [ $? -gt 0  ];then
        echo "scons安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -xvf scons-2.3.0.tar.gz
    cd scons-2.3.0
    python setup.py install
    cd ../
    rm -rf scons-2.3.0*

    #安裝serf
    wget https://www.apache.org/dist/serf/serf-1.3.10.tar.bz2 --no-check-certificate
    if [ $? -gt 0  ];then
        echo "serf安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -xvf serf-1.3.10.tar.bz2
    cd serf-1.3.10
    scons PREFIX=/usr/local/serf APR=/usr/local/apr APU=/usr/local/apr-util
    scons install
    cp /usr/local/serf/lib/libserf-1.so* /usr/lib64/
    cd ../
    rm -rf serf-1.3.10*

    #安裝svn
    wget https://dlcdn.apache.org/subversion/subversion-1.14.2.tar.gz --no-check-certificate
    if [ $? -gt 0  ];then
        echo "svn安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -xvf subversion-1.14.2.tar.gz
    cd subversion-1.14.2
    mkdir build_dir && cd build_dir
    ../configure --prefix=/usr/local/svn --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-sqlite=/usr/local/sqlite --with-zlib=/usr/local/zlib --with-serf=/usr/local/serf --with-lz4=internal --with-utf8proc=internal
    make -j8 && make install
    echo "export PATH=/usr/local/svn/bin:\$PATH" >> /etc/profile
    source /etc/profile
    cd ../../
    rm -rf subversion-1.14.2*
}

function install_python3() {
    curl -O https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz
    if [ $? -gt 0  ];then
        echo "python3安装包下载失败 请手动执行"
        exit 1
    fi 
    wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/yum --no-check-certificate
    chmod 775 yum
    wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/urlgrabber-ext-down --no-check-certificate
	chmod 775 urlgrabber-ext-down
    tar -xvf Python-3.7.6.tgz
    cd Python-3.7.6
    mkdir build && cd build
    ../configure --prefix=/usr/local/python37 --enable-shared
    make -j8 && make install
    cp libpython3.7m.so.1.0 /usr/lib64
    cd ../../
    rm -rf Python-3.7.6*
    pypath=`which python`
    if [ $? -eq 0  ]
    then
        # bak python
        Sp=${pypath%/*}
        mv $pypath $Sp/python_bak
    fi
    ln -s /usr/local/python37/bin/python3 /bin/python3
    ln -s /usr/local/python37/bin/python3 /usr/bin/python 
    ln -s /usr/local/python37/bin/pip3 /usr/bin/pip
    ln -s /usr/local/python37/bin/pip3 /usr/bin/pip3
    mv -f ./yum /usr/bin/yum
    mv -f ./urlgrabber-ext-down /usr/libexec/urlgrabber-ext-down
}

function install_nvim() {
    pip3 install --upgrade pip
    pip3 install pynvim
    pip3 install pygments
    pip3 install neovim
    #wget http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.gz --no-check-certificate
    #if [ $? -gt 0  ];then
    #    echo "glibc安装包下载失败 请手动执行"
    #    exit 1
    #fi 
    #tar -xvf glibc-2.18.tar.gz
    #cd glibc-2.18
    #mkdir build && cd build
    #../configure --prefix=/usr
    #make -j8 && make install
    #cd ../../
    #rm -rf glibc-2.18*
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    if [ $? -gt 0  ];then
        echo "nvim安装包下载失败 请手动执行"
        exit 1
    fi 
    chmod 777 nvim.appimage
    yum remove -y vim
    rm -f /bin/vim
    rm -f /bin/vi
    mv nvim.appimage /usr/bin/nvim.appimage
    ln -s /usr/bin/nvim.appimage /bin/vim
    ln -s /usr/bin/nvim.appimage /bin/vi
    npm i -g bash-language-server
}

function install_gtags(){
    wget https://ftp.gnu.org/pub/gnu/global/global-6.6.10.tar.gz --no-check-certificate
    if [ $? -gt 0  ];then
        echo "gtags安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -xvf global-6.6.10.tar.gz
    cd global-6.6.10
    mkdir build && cd build
    ../configure --prefix=/usr/local/gtags --with-sqlite3=/usr/local/sqlite
    make -j8 && make install
    echo "export PATH=/usr/local/gtags/bin:\$PATH" >> /etc/profile
    source /etc/profile
    cd ../../
    rm -rf global-6.6.10*
}

function install_gdb() {
    #卸载gdb
    yum remove gdb -y

    if [ ! -d /data ]
    then
        mkdir /data
    fi
    
    if [ ! -d /data/thirdparty ]
    then
        mkdir /data/thirdparty
    fi
    
    #安装beauty print
    if [ ! -d /data/thirdparty/python ]
    then 
        svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python
        if [ $? -gt 0  ];then
            echo "beauty print安装包下载失败 请手动执行"
            exit 1
        fi 
        mv python /data/thirdparty
    fi

    if [ ! -d /etc/gdb ]
    then
        mkdir /etc/gdb
    fi
    
    #拷贝gdbinit
    wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/gdbinit
    mv gdbinit /etc/gdb/gdbinit
    
    #安装gmp
    wget https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.gz --no-check-certificate
    if [ $? -gt 0  ];then
        echo "gmp安装包下载失败 请手动执行"
        exit 1
    fi
    tar -xvf gmp-6.3.0.tar.gz
    cd gmp-6.3.0
    mkdir build && cd build
    ../configure --prefix=/usr/local/gmp
    make -j8 && make install
    cd ../../
    rm -rf gmp-6.3.0*
    
    #安装gdb
    wget https://ftp.gnu.org/gnu/gdb/gdb-10.1.tar.gz --no-check-certificate
    if [ $? -gt 0  ];then
        echo "gdb安装包下载失败 请手动执行"
        exit 1
    fi 
    tar -xvf gdb-10.1.tar.gz
    cd gdb-10.1
    mkdir build && cd build
    ../configure --prefix=/usr/local/gdb --with-python=/usr/bin/python2 --enable-tui=yes --with-system-gdbinit=/etc/gdb/gdbinit --with-libgmp-prefix=/usr/local/gmp
    make -j8 && make install
    echo "export PATH=/usr/local/gdb/bin:\$PATH" >> /etc/profile
    source /etc/profile
    cd ../../
    rm -rf gdb-10.1*
}

function install_nxx_evn() {
    #安装ctags
    git clone https://github.com/universal-ctags/ctags.git ctags
    if [ $? -gt 0  ];then
        echo "ctags安装包下载失败 请手动执行"
        exit 1
    fi
    cd ctags
    ./autogen.sh
    mkdir build && cd build
    ../configure --prefix=/usr/local/ctags
    make -j8 && make install
    echo "export PATH=/usr/local/ctags/bin:\$PATH" >> /etc/profile
    source /etc/profile
    cd ../../
    rm -rf ctags
    
    #拷贝protoc xlua.so，librsa.a
    wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/protoc --no-check-certificate
    chmod +x protoc
    mv protoc /usr/local/bin/
    
    wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/libxlua.so --no-check-certificate
    cp libxlua.so /usr/local/lib64/
    mv libxlua.so /usr/lib64/
    
    wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/librsa.a --no-check-certificate
    mv librsa.a /usr/local/lib/
}

echo "请使用root权限运行此脚本"
root_need
pre_install_env
install_cmake
install_go
install_svn
install_python3
install_nodejs
install_nvim
install_gtags
install_gdb
install_nxx_evn
