#!/bin/bash

LINUX_BUILD_URL="https://raw.githubusercontent.com/wangrui1hao/LinuxBuild/main"

# 检测执行是否成功
function check_success() {
    if [ $? -gt 0  ]; then
        echo "retcode != 0, check failed!"
        exit 1
    fi 
}

# 非root用户检测
function not_root_need() {
    if [[ $EUID -eq 0 ]]; then
        echo "Error:This script must be run as not root!" 1>&2
        exit 1
    fi
}

not_root_need
source /etc/profile && sudo ldconfig

# 递归修改/data目录归属权
cd ~ && sudo chown -R $USER:$USER /data
check_success

# bashrc
is_install=`cat ~/.bashrc | grep "bashrc_version"`
if [ -z "$is_install" ]; then
    wget -c $LINUX_BUILD_URL/bash/bashrc -O ~/bashrc && \
    mv -f ~/.bashrc ~/.bashrc_back && \
    mv ~/bashrc ~/.bashrc && \
    source ~/.bashrc
    check_success
fi

# protoc-gen-gofast
is_install=`ls $HOME/go/bin 2>&1 | grep protoc-gen-gofast`
if [ -z "$is_install" ]; then
    go get github.com/gogo/protobuf/protoc-gen-gofast
    check_success
fi

# protoc-gen-go
is_install=`ls $HOME/go/bin 2>&1 | grep protoc-gen-go`
if [ -z "$is_install" ]; then
    go install github.com/golang/protobuf/protoc-gen-go@latest
    check_success
fi

# easyjson
is_install=`ls $HOME/go/bin 2>&1 | grep easyjson`
if [ -z "$is_install" ]; then
    go install github.com/mailru/easyjson/...@latest
    check_success
fi

# stringer
is_install=`ls $HOME/go/bin 2>&1 | grep stringer`
if [ -z "$is_install" ]; then
    go install golang.org/x/tools/cmd/stringer@latest
    check_success
fi

# gopls
is_install=`ls $HOME/go/bin 2>&1 | grep gopls`
if [ -z "$is_install" ]; then
    go install golang.org/x/tools/gopls@latest
    check_success
fi

# dlv
is_install=`ls $HOME/go/bin 2>&1 | grep dlv`
if [ -z "$is_install" ]; then
    go install github.com/go-delve/delve/cmd/dlv@latest
    check_success
fi

# golangci-lint
is_install=`ls $HOME/go/bin 2>&1 | grep golangci-lint`
if [ -z "$is_install" ]; then
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $HOME/go/bin v1.55.0
    check_success
fi

# gopath-bin
is_install=`cat /etc/profile | grep "HOME/go/bin"`
if [ -z "$is_install" ]; then
    echo "export PATH=\$HOME/go/bin:\$PATH" | sudo tee -a /etc/profile && \
    source /etc/profile
    check_success
fi

# nvim config
need_pull_nvim="1"
if [ -d ~/.config/nvim ]; then
    cd ~/.config/nvim
    is_install=`git status 2>&1 | grep "main"`
    if [ -n "$is_install" ]; then
        need_pull_nvim="0"
    fi
    cd ~
fi
if [ $need_pull_nvim == "1" ]; then
    mkdir -p ~/.config && rm -rf ~/.config/nvim && \
    cd ~/.config && git clone https://github.com/wangrui1hao/nvim-for-server.git nvim --depth=1
    check_success
    cd ~
fi

# ssh config
if [ ! -f ~/.ssh/config ]; then
    mkdir -p ~/.ssh && cd ~/.ssh && \
    wget -c $LINUX_BUILD_URL/openssh/ssh_config -O config && \
    chmod 600 ~/.ssh/config && \
    sudo sed -i "s@^HostKey /etc/ssh/ssh_host_@#HostKey /etc/ssh/ssh_host_@g; \
        s@#HostKey /etc/ssh/ssh_host_rsa_key@HostKey /etc/ssh/ssh_host_rsa_key@g; \
        s@#Port.*@Port 2224@g" /etc/ssh/sshd_config && \
    sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
    check_success
    cd ~
fi

# svn
if [ ! -f ~/.subversion/config ]; then
    mkdir -p ~/.subversion && echo -e "[auth]\npassword-stores = gpg-agent" > ~/.subversion/config
    check_success
fi

# init.d 
if [ ! -f /etc/init.d/custom ]; then
    wget -c $LINUX_BUILD_URL/init.d/custom && \
    sudo mv ./custom /etc/init.d/custom
    check_success
fi

echo "************************************************"
echo "*用户基础环境安装完成，请参照README进行后续配置*"
echo "************************************************"
