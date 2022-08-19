#!/bin/bash

function not_root_need() {
    if [[ $EUID -eq 0 ]]; then
        echo "Error:This script must be run as not root!" 1>&2
        exit 1
    fi
}

not_root_need

yum install -y git
cd ~/
if [ ! -d ~/.config ];then
    mkdir ~/.config
fi 
if [ -d ~/.config/nvim ];then 
    rm -rf ./nvim
fi 

cd ~/.config

echo "开始clone 远端的vim 配置"
git clone https://github.com/wangrui1hao/nvim-for-server.git nvim --depth=1 
echo "clone 完成 enjoy your vim"