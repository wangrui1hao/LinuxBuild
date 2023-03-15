# LinuxBuild

## 环境
> - Docker Desktop 4.11.1
> - CentOS Linux release 7.9.2009

## 介绍
项目开发环境需要自己进行手动配置，且缺乏Linux环境搭建相关Wiki，新人容易踩坑，每次换新机器或者自己折腾系统完了之后需要自己修改配置一次Linux的环境很麻烦，为了方便自己以及新人之后使用，就做了这个半自动化配置文件。

## 软件依赖
**下载不下来的时候点击这里下载放到安装目录**
> - [go-1.16.2](https://dl.google.com/go/go1.16.2.linux-amd64.tar.gz)
> - [nodejs-16.16.0](https://cdn.npmmirror.com/binaries/node/v16.16.0/node-v16.16.0-linux-x64.tar.gz)
> - [apr-1.7.0](https://dlcdn.apache.org//apr/apr-1.7.0.tar.gz)
> - [apr-util-1.6.1](https://dlcdn.apache.org//apr/apr-util-1.6.1.tar.gz)
> - [sqlite-3.39.2](https://www.sqlite.org/2022/sqlite-autoconf-3390200.tar.gz)
> - [zlib-1.2.12](http://www.zlib.net/zlib-1.2.12.tar.gz)
> - [scons-2.3.0](https://cfhcable.dl.sourceforge.net/project/scons/scons/2.3.0/scons-2.3.0.tar.gz)
> - [serf-1.3.9](https://www.apache.org/dist/serf/serf-1.3.9.tar.bz2)
> - [subversion-1.14.2](https://dlcdn.apache.org/subversion/subversion-1.14.2.tar.gz)
> - [python-3.7.6](https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz)
> - [glibc-2.18](http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.gz)
> - [nvim-0.7.2](https://github.com/neovim/neovim/releases/latest/download/nvim.appimage)
> - [global-6.6.8](https://ftp.gnu.org/pub/gnu/global/global-6.6.8.tar.gz)
> - [beauty print](svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python)
> - [gdb-10.1](https://ftp.gnu.org/gnu/gdb/gdb-10.1.tar.gz)
> - [protoc-3.6.1](https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip)
> - [ctags](https://github.com/universal-ctags/ctags.git)
> - [xLua-2.1.14](https://github.com/Tencent/xLua/archive/refs/tags/v2.1.14.tar.gz)
> - [其他一些小脚本](https://github.com/wangrui1hao/LinuxBuild)

## 安装教程
> - 特别提示：最好在干净的linux环境下执行脚本，脚本健壮性不是很高，请谅解。
1. 使用`sudo`执行以下命令，输入密码后开始自动安装
```shell 
curl https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/build_linux_use_root.sh | sudo bash
```
2. 确认安装成功后，使用非`root`用户执行以下命令，过程中需要输入一次sudo密码，进行二进制拷贝操作，执行完毕后重新打开终端执行后续操作
```shell
curl https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/build_linux_not_root.sh | bash
```
3. 全部安装成功之后启动vim，这个时候第一次启动我的配置会自动检测有没有相关插件，进行安装
```shell
#如果安装失败，在vim命令模式执行
:PlugInstall

#全部安装成功后，执行以下命令更新插件数据
:UpdateRemotePlugins
:CocInstall coc-sh
```
4. svn下载项目服务器代码与配置到相应目录
5. 在bashrc或profile中添加GOPATH目录

## 使用说明
脚本中已经按我的习惯配置好了vim快捷键，如有需要可在`~/.config/nvmi/setting`目录下，对相应插件进行快捷键定制、修改操作。
> - **快捷键中存在Alt键，请在对应终端中开启Alt键作为Mate键的映射**
> - Alt-Shift-O 搜索文件名（Tab切换`输入`与`选择`模式，下同）
> - Alt-Shift-P 本次vim进程打开过的文件
> - Ctrl-Alt-Left 后退操作
> - Ctrl-Alt-Right 前进操作
> - Alt-G / F12 跳转到定义
> - Alt-M 列出本文件的所有函数进行速览，回车进行跳转
> - Alt-Shift-F 搜索光标所在单词的引用
> - Ctrl-F 回车后，搜索光标所在单词在项目中的所有使用（需要配合Gtags生成文件）

vim中已集成gopls与go fmt，保存文件时会自动进行格式化操作，更多功能请自行探索。

## 安装脚本详细说明 
**这一切上面的脚本都给你做了！万一遇到问题可以使用这个进行逐步安装查错！**
> 如果安装出现中断你可以自行下载相关的依赖文件进行，然后再根据脚本内容进行执行。国内的云可能下载不下来，我已经在[软件依赖](#软件依赖)中把相关链接贴了出来。

### cmake-3.10.0
```shell
wget https://cmake.org/files/v3.10/cmake-3.10.0.tar.gz
tar -zxvf cmake-3.10.0.tar.gz
cd cmake-3.10.0
./bootstrap
gmake -j8
make install
```

### nodejs-16.16.0
nodejs官网的一键安装脚本使用有问题，这里我们还是选择源码编译安装
```shell
wget https://cdn.npmmirror.com/binaries/node/v16.16.0/node-v16.16.0-linux-x64.tar.gz --no-check-certificate
tar -xvf node-v16.16.0-linux-x64.tar.gz
mv node-v16.16.0-linux-x64 /usr/local/node.js
ln -s /usr/local/node.js/bin/node /usr/bin/node
ln -s /usr/local/node.js/bin/npm /usr/bin/npm
npm install -g yarn
echo "export NODE_HOME=/usr/local/node.js" >> /etc/profile
echo "export PATH=/usr/local/node.js/bin:\$PATH" >> /etc/profile
echo "export NODE_PATH=$NODE_HOME/lib/node_modules:\$PATH" >> /etc/profile
source /etc/profile
```

### go-1.16.2
这里我们项目使用的是1.16版本，直接下载、解压、配置环境变量就行
```shell
wget https://dl.google.com/go/go1.16.2.linux-amd64.tar.gz
tar -C /usr/local -xvf go1.16.2.linux-amd64.tar.gz
echo "export PATH=/usr/local/go/bin:\$PATH" >> /etc/profile
echo "export GOROOT=/usr/local/go" >> /etc/profile
source /etc/profile
```

### subversion-1.14.2
svn这里安装依赖了一大堆环境，个人配置起来会比较麻烦，如果出问题里可以跟着脚本内容一步步进行
```shell
#卸载原生svn
yum remove -y svn

#安装apr
wget https://dlcdn.apache.org//apr/apr-1.7.0.tar.gz --no-check-certificate
tar -xvf apr-1.7.0.tar.gz
cd apr-1.7.0
mkdir build_dir && cd build_dir
../configure --prefix=/usr/local/apr
make -j8 && make install

#安装apr-util
wget https://dlcdn.apache.org//apr/apr-util-1.6.1.tar.gz --no-check-certificate
tar -xvf apr-util-1.6.1.tar.gz
cd apr-util-1.6.1
mkdir build_dir && cd build_dir
../configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr
make -j8 && make install

#安装sqlite3
wget https://www.sqlite.org/2022/sqlite-autoconf-3390200.tar.gz --no-check-certificate
tar -xvf sqlite-autoconf-3390200.tar.gz
cd sqlite-autoconf-3390200
mkdir build && cd build
../configure --prefix=/usr/local/sqlite
make -j8 && make install

#安裝zlib
wget http://www.zlib.net/zlib-1.2.12.tar.gz --no-check-certificate
tar -xvf zlib-1.2.12.tar.gz
cd zlib-1.2.12
mkdir build && cd build
../configure --prefix=/usr/local/zlib
make -j8 && make install

#安装scons
wget https://cfhcable.dl.sourceforge.net/project/scons/scons/2.3.0/scons-2.3.0.tar.gz --no-check-certificate
tar -xvf scons-2.3.0.tar.gz
cd scons-2.3.0
python setup.py install

#安裝serf
wget https://www.apache.org/dist/serf/serf-1.3.9.tar.bz2 --no-check-certificate
tar -xvf serf-1.3.9.tar.bz2
cd serf-1.3.9
#这里必须使用scons安装，所以要先用python安装scons，还得是python2，所以python3的安装一般在此之后
scons PREFIX=/usr/local/serf APR=/usr/local/apr APU=/usr/local/apr-util
scons install
cp /usr/local/serf/lib/libserf-1.so* /usr/lib64/

#安裝svn
wget https://dlcdn.apache.org/subversion/subversion-1.14.2.tar.gz --no-check-certificate
tar -xvf tar -xvf subversion-1.14.2.tar.gz
cd subversion-1.14.2
mkdir build_dir && cd build_dir
#指定一大堆环境目录。。
../configure --prefix=/usr/local/svn --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-sqlite=/usr/local/sqlite --with-zlib=/usr/local/zlib --with-serf=/usr/local/serf --with-lz4=internal --with-utf8proc=internal
make -j8 && make install
echo "export PATH=/usr/local/svn/bin:\$PATH" >> /etc/profile
source /etc/profile
```
### python-3.7.6
编译安装时要注意centos7上需要拷贝动态库，以及yum、urlgrabber-ext-down文件的修改
```shell
#安装python
curl -O https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz
tar -xvf Python-3.7.6.tgz
cd Python-3.7.6
mkdir build && cd build
../configure --prefix=/usr/local/python37 --enable-shared
make -j8 && make install
cp libpython3.7m.so.1.0 /usr/lib64

#修改软链
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

#修改yum、rlgrabber-ext-down
wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/yum --no-check-certificate
chmod 771 yum
wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/urlgrabber-ext-down --no-check-certificate
mv ./yum /usr/bin/yum
mv ./urlgrabber-ext-down /usr/libexec/urlgrabber-ext-down

#升级一下pip
pip3 install --upgrade pip
```

### nvim-0.7.2
neovim的安装确实特别简单，appimage已经免除了需要自己编译的各种问题。这里安装glibc-2.18是因为Clangd使用需要依赖，如果只进行go相关开发，这一步可以跳过。脚本内安装了目前比较主流的coc和leaderf插件，搭配gopls进行使用，配置拷贝的是我个人配置，有需要的话可以自行替换。
```shell
#先安装一些依赖项
pip3 install pynvim
pip3 install pygments
pip3 install neovim

#安装glibc
wget http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.gz --no-check-certificate
tar -xvf glibc-2.18.tar.gz
cd glibc-2.18
mkdir build && cd build
../configure --prefix=/usr
make -j8 && make install

#安装nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
if [ $? -gt 0  ];then
    echo "nvim安装包下载失败 请手动执行"
    exit 1
fi 
chmod 777 nvim.appimage

#移除原本系统中的vim、vi
yum remove -y vim
rm -f /bin/vim
rm -f /bin/vi

#建立nvim软链
mv nvim.appimage /usr/bin/nvim.appimage
ln -s /usr/bin/nvim.appimage /bin/vim
ln -s /usr/bin/nvim.appimage /bin/vi

#安装bash-language-server
npm i -g bash-language-server
```

### global-6.6.8
gtags是目前比较好用的代码跟踪工具，且能较好地支持Go项目，leaderF的使用也需要gtags的支持，比较推荐大家使用Gtags替代以前的ctags，具体使用方式请自行参考官网介绍
```shell
wget https://ftp.gnu.org/pub/gnu/global/global-6.6.8.tar.gz --no-check-certificate
tar -xvf global-6.6.8.tar.gz
cd global-6.6.8
mkdir build && cd build

#这里我们指定sqlite作为数据库，sqlite在svn安装依赖中已经装好了
../configure --prefix=/usr/local/gtags --with-sqlite3=/usr/local/sqlite
make -j8 && make install
echo "export PATH=/usr/local/gtags/bin:\$PATH" >> /etc/profile
source /etc/profile
```

### gdb-10.1
GDB可以用来调试Go代码，并且我在脚本里内置了BeautyPrint插件，可以打印出一些正常途径看不到的内存信息，这里要注意的是，gdbinit我在安装的时候指定了路径在/etc/gdb/gdbinit，所以常用的~/.gdbinit是失效状态，如果有需求的话可以再etc目录下进行修改。同时BeautyPrint目录被指定在了/data/thirdparty/python，有需求的话也可以在此目录下进行修改
```shell
#卸载gdb
yum remove gdb -y

if [ ! -d /data/thirdparty ]
then
    mkdir /data/thirdparty
fi

#安装beauty print
if [ ! -d /data/thirdparty/python ]
then 
    svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python
    mv -r python /data/thirdparty
fi

if [ ! -d /etc/gdb ]
then
    mkdir /etc/gdb
fi

#拷贝gdbinit
wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/gdbinit
mv gdbinit /etc/gdb/gdbinit

#安装gdb
wget https://ftp.gnu.org/gnu/gdb/gdb-10.1.tar.gz --no-check-certificate
tar -xvf gdb-10.1.tar.gz
cd gdb-10.1
mkdir build && cd build

#这里指定了--enable-tui=yes，所以在gdb中按Ctrl-x-a可以进入图形化界面
../configure --prefix=/usr/local/gdb --with-python=/usr/bin/python2 --enable-tui=yes --with-system-gdbinit=/etc/gdb/gdbinit
make -j8 && make install
echo "export PATH=/usr/local/gdb/bin:\$PATH" >> /etc/profile
source /etc/profile
```

### 项目环境依赖项
项目中使用了protoc、xlua等，环境部署KM上只有windows相关流程，缺乏Linux部署步骤，在此我将需要的内容一一列出，关键内容不再源码编译，直接拷贝我已经编译好的二进制与库文件即可
```shell
#安装ctags
git clone https://github.com/universal-ctags/ctags.git ctags
cd ctags
./autogen.sh
mkdir build && cd build
../configure --prefix=/usr/local/ctags
make -j8 && make install
echo "export PATH=/usr/local/ctags/bin:\$PATH" >> /etc/profile
source /etc/profile

#拷贝protoc xlua.so，librsa.a
wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/protoc --no-check-certificate
mv protoc /usr/local/bin/

wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/libxlua.so --no-check-certificate
cp libxlua.so /usr/local/lib64/
mv libxlua.so /usr/lib64/

wget https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/librsa.a --no-check-certificate
mv librsa.a /usr/local/lib/
```

### 非root脚本
以下内容使用sudo运行会出问题，所以单独封成一个脚本，请使用非root权限运行，内容大致如下：
- Go环境依赖项
```shell
cd ~/
go get github.com/gogo/protobuf/protoc-gen-gofast
go get -u github.com/golang/protobuf/protoc-gen-go@v1.3.2
go get -u github.com/mailru/easyjson/...
go get golang.org/x/tools/cmd/stringer
go install golang.org/x/tools/gopls@latest
go env -w GO111MODULE=off

#此处拷贝二进制需要sudo权限
sudo cp go/bin/* /usr/local/bin/
```

- nvim配置文件
```shell
yum install -y git
cd ~/
if [ ! -d ~/.config ];then
    mkdir ~/.config
fi 
if [ -d ~/.config/nvim ];then 
    rm -rf ./nvim
fi 

cd ~/.config

git clone https://github.com/wangrui1hao/nvim-for-server.git nvim --depth=1 
```

### 支持language server 
脚本内已经安装好了Go的language server：gopls，如果需要安装其他语言的话，例如C、C++:
```shell
wget https://github.com/clangd/clangd/releases/download/11.0.0/clangd-linux-11.0.0.zip
unzip clangd-linux-11.0.0.zip
mv clangd_11.0.0/ /usr/local/clang
ln -s /usr/local/clang/bin/clangd /usr/bin/clangd
```
然后在coc-settings.json中进行对应语言的配置即可，相关配置规则请参考官网示例

### 启动nvim
第一次启动的时候需要在命令行界面输入`:PluginInstall`，然后等等等。。。一直等到全部完装完毕，左上角显示`Finishing ... Done!`，退出再进入一次就可以看到已经设置好的nvim配置了
使用`:UpdateRemotePlugins`来更新一下远端的代码配置

## 结束语
至此，Linux的基本环境就已经全部配置完毕了，剩下的就是将自己的项目代码使用SVN克隆到本地，然后愉快的开始Linux开发之旅了！