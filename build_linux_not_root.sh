#!/bin/bash

function not_root_need() {
    if [[ $EUID -eq 0 ]]; then
        echo "Error:This script must be run as not root!" 1>&2
        exit 1
    fi
}

not_root_need

#安装go相关
cd ~/
go get github.com/gogo/protobuf/protoc-gen-gofast
go get -u github.com/golang/protobuf/protoc-gen-go@v1.3.2
go get -u github.com/mailru/easyjson/...
go get golang.org/x/tools/cmd/stringer
go install golang.org/x/tools/gopls@latest
go env -w GO111MODULE=off
sudo cp go/bin/* /usr/local/bin/

#拉取nvim配置
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