#!binbash

function root_need() {
    if [[ $EUID -ne 0 ]]; then
        echo ErrorThis script must be run as root! 1&2
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
}

function install_cmake() {
    wget httpscmake.orgfilesv3.10cmake-3.10.0.tar.gz
    tar -zxvf cmake-3.10.0.tar.gz
    cd cmake-3.10.0
    .bootstrap
    gmake -j8
    make install
    cd ..
    rm -rf cmake-3.10.0
}

function install_nodejs() {
    curl --fail -LSs httpsinstall-node.now.shlatest  sh
}

function install_go() {
    wget httpsdl.google.comgogo1.16.2.linux-amd64.tar.gz
    tar -C usrlocal -xvf go1.16.2.linux-amd64.tar.gz
    echo export PATH=$PATHusrlocalgobin  etcprofile
    echo export GOROOT=usrlocalgo  etcprofile
    source etcprofile
    rm -rf go1.16.2.linux-amd64.tar.gz
}

function install_svn() {
    #卸载原生svn
    yum remove -y svn

    #安装apr
    wget httpsdlcdn.apache.orgaprapr-1.7.0.tar.gz --no-check-certificate
    tar -xvf apr-1.7.0.tar.gz
    cd apr-1.7.0
    mkdir build_dir && cd build_dir
    ..configure --prefix=usrlocalapr
    make -j8 && make install
    cd ....
    rm -rf apr-1.7.0

    #安装apr-util
    wget httpsdlcdn.apache.orgaprapr-util-1.6.1.tar.gz --no-check-certificate
    tar -xvf apr-util-1.6.1.tar.gz
    cd apr-util-1.6.1
    mkdir build_dir && cd build_dir
    ..configure --prefix=usrlocalapr-util --with-apr=usrlocalapr
    make -j8 && make install
    cd ....
    rm -rf apr-util-1.6.1

    #安装sqlite3
    wget httpswww.sqlite.org2022sqlite-autoconf-3390200.tar.gz --no-check-certificate
    tar -xvf sqlite-autoconf-3390200.tar.gz
    cd sqlite-autoconf-3390200
    mkdir build && cd build
    ..configure --prefix=usrlocalsqlite
    make -j8 && make install
    cd ....
    rm -rf sqlite-autoconf-3390200

    #安裝zlib
    wget httpwww.zlib.netzlib-1.2.12.tar.gz --no-check-certificate
    tar -xvf zlib-1.2.12.tar.gz
    cd zlib-1.2.12
    mkdir build && cd build
    ..configure --prefix=usrlocalzlib
    make -j8 && make install
    cd ....
    rm -rf zlib-1.2.12

    #安装scons
    wget httpscfhcable.dl.sourceforge.netprojectsconsscons2.3.0scons-2.3.0.tar.gz --no-check-certificate
    tar -xvf scons-2.3.0.tar.gz
    cd scons-2.3.0
    python setup.py install
    cd ..
    rm -rf scons-2.3.0

    #安裝serf
    wget httpswww.apache.orgdistserfserf-1.3.9.tar.bz2 --no-check-certificate
    tar -xvf serf-1.3.9.tar.bz2
    cd serf-1.3.9
    scons PREFIX=usrlocalserf APR=usrlocalapr APU=usrlocalapr-util
    scons install
    cp usrlocalserfliblibserf-1.so usrlib64
    cd ..
    rm -rf serf-1.3.9

    #安裝svn
    wget httpsdlcdn.apache.orgsubversionsubversion-1.14.2.tar.gz --no-check-certificate
    tar -xvf tar -xvf subversion-1.14.2.tar.gz
    cd subversion-1.14.2
    mkdir build_dir && cd build_dir
    ..configure --prefix=usrlocalsvn --with-apr=usrlocalapr --with-apr-util=usrlocalapr-util --with-sqlite=usrlocalsqlite --with-zlib=usrlocalzlib --with-serf=usrlocalserf --with-lz4=internal --with-utf8proc=internal
    make -j8 && make install
    echo export PATH=usrlocalsvnbin$PATH  etcprofile
    source etcprofile
    cd ....
    rm -rf subversion-1.14.2
}

function install_python3() {
    if [ -d usrlocalpython37 ];
    then
        rm -rf usrlocalpython37
    fi

echo 请使用root权限运行此脚本
root_need
pre_install_env
install_cmake
#install_nodejs
install_go
install_svn
install_python3
