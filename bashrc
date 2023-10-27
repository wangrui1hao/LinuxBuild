# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export SCREENDIR=$HOME/.screen

# bashrc_version 0.0.1

# golang环境相关
export GOPATH="$HOME/go:$NXXCDC"
export GO111MODULE=auto

# 其他
export GTAGSCONF=/usr/local/gtags/share/gtags/gtags.conf
export GTAGSLABEL=pygments
export SVN_EDITOR=vim

# 端口映射
function AddressPortMapping {
	# 需要映射的端口ID加在这里
	PORT_MAPPING=(
		80
		2223
		3306
		8500
	)
	LINUX_IP=`ifconfig | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}'`
	
	for CURR_PORT in ${PORT_MAPPING[@]}
	do
		NEW_STRING="netsh interface portproxy add v4tov4 listenport="$CURR_PORT" listenaddress=0.0.0.0 connectport="$CURR_PORT" connectaddress="$LINUX_IP";"$NEW_STRING
	done
	# 此处的'pc'可在配置文件内替换为自己的windows地址，~/.ssh/config
	ssh pc $NEW_STRING > /dev/null
}

# 启动redis-server
function RunRedis {
	redis-server /data/Redis/conf/redis.conf
}

# 启动consul
function RunConsul {
	consul agent -server -bootstrap -client 0.0.0.0 -ui -data-dir=/data/Consul/data -config-dir=/data/Consul/conf > /data/Consul/logs/consul-log.log &
}

# 启动mysql
function RunMysql {
	#sudo mkdir -p /var/run/mysqld
	#sudo chown mysql.mysql /var/run/mysqld
	sudo systemctl restart mysqld
}

# 启动sshd
function RunSshd {
	sudo systemctl restart sshd
}

# 启动一键脚本
function RestartRun {
	AddressPortMapping > /dev/null &
	RunRedis > /dev/null &
	RunConsul > /dev/null &
	screen -wipe > /dev/null &
	SVNAgent > /dev/null &
	wait
}

# 重启svn托管服务
function SVNAgent {
	pkill gpg-agent
	gpg-agent --daemon
}
