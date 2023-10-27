#!/bin/bash

function not_root_need() {
    if [[ $EUID -eq 0 ]]; then
        echo "Error:This script must be run as not root!" 1>&2
        exit 1
    fi
}

not_root_need
cd ~ && sudo chown -R $USER:$USER /data

# protoc-gen-gofast
is_install=`ls $HOME/go/bin 2>&1 | grep protoc-gen-gofast`
if [ -z "$is_install" ]; then
    go get github.com/gogo/protobuf/protoc-gen-gofast
fi

# protoc-gen-go
is_install=`ls $HOME/go/bin 2>&1 | grep protoc-gen-go`
if [ -z "$is_install" ]; then
    go install github.com/golang/protobuf/protoc-gen-go@latest
fi

# easyjson
is_install=`ls $HOME/go/bin 2>&1 | grep easyjson`
if [ -z "$is_install" ]; then
    go install github.com/mailru/easyjson/...@latest
fi


# stringer
is_install=`ls $HOME/go/bin 2>&1 | grep stringer`
if [ -z "$is_install" ]; then
    go install golang.org/x/tools/cmd/stringer@latest
fi

# gopls
is_install=`ls $HOME/go/bin 2>&1 | grep gopls`
if [ -z "$is_install" ]; then
    go install golang.org/x/tools/gopls@latest
fi

# dlv
is_install=`ls $HOME/go/bin 2>&1 | grep dlv`
if [ -z "$is_install" ]; then
    go install github.com/go-delve/delve/cmd/dlv@latest
fi

# golangci-lint
is_install=`ls $HOME/go/bin 2>&1 | grep golangci-lint`
if [ -z "$is_install" ]; then
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $HOME/go/bin v1.55.0
fi

# gopath-bin
is_install=`cat /etc/profile | grep "HOME/go/bin"`
if [ -z "$is_install" ]; then
    echo "export PATH=\$HOME/go/bin:\$PATH" | sudo tee -a /etc/profile
    source /etc/profile
fi

# bashrc
is_install=`cat ~/.bashrc | grep "bashrc_version"`
if [ -z "$is_install" ]; then
    wget -c https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main/bashrc -O ~/.bashrc
    source ~/.bashrc
fi

#拉取nvim配置
mkdir -p ~/.config && rm -rf ~/.config/nvim
cd ~/.config && git clone https://github.com/wangrui1hao/nvim-for-server.git nvim --depth=1 


