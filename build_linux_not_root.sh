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
export GO111MODULE=on
go get -u github.com/golang/protobuf/protoc-gen-go@v1.3.2
export GO111MODULE=auto
go get -u github.com/mailru/easyjson/...
go get -u golang.org/x/lint/golint
go get golang.org/x/tools/cmd/stringer
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $HOME/go/bin v1.51.2
echo "export PATH=\$HOME/go/bin:\$PATH" | sudo tee -a /etc/profile
sudo source /etc/profile

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
