#!/bin/bash

# install dependencies
function install_dep(){
	yum update -y
	yum install git vim -y

	# install history and lanuage
	bash <(curl -s http://git.oschina.net/x242025/Shell/raw/master/CentOS/set_locale.sh)
	bash <(curl -s http://git.oschina.net/x242025/Shell/raw/master/CentOS/history.sh)

	#  install python environment of shaowsocks
	yum install m2crypto python-setuptools -y
	easy_install pip
	pip install cymysql
}



echo -ne "\e[0;32mPlease input the remote kcptun port: \e[47m"
read remote_kcptun_port

echo -ne "\e[0;32mPlease input kcptun password: \e[47m"
read kcptun_password

echo -ne "\e[0;32mPlease input kcptun mode: \e[47m"
read kcptun_mode

echo -ne "\e[0;32mPlease input local shadowsocks port: \e[47m"
read local_ss_port

echo -ne "\e[0;32mPlease input local shadowsocks password: \e[47m"
read local_ss_password

read "Please any key to continue or CTRL + C to pause..."


install_dep
pip install shadowsocks
wget https://github.com/xingtingyang/kcss.git
cd kcss


cat > ./shadowsocks.json << EOF
{
    "server":"::0",  
    "server_port":${local_ss_port},  
    "local_port":1080,  
    "password":"${local_ss_password}",  
    "timeout":600,  
    "method":"aes-256-cfb"
}
EOF

cat > ./kcptun.json << EOF
{
    "listen": ":${remote_kcptun_port}",
    "target": "127.0.0.1:${local_ss_port}",
    "key": "${kcptun_password}",
    "mode": "${kcptun_mode}"
}
EOF


script_path=~/kcss

$script_path/kcss.sh start
echo "$script_path/kcss.sh start" >> /etc/rc.local








