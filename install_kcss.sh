#!/bin/bash

# install dependencies
function install_dep(){
	yum update -y
	yum install git -y

	# install history and lanuage
	bash <(curl -s http://git.oschina.net/x242025/Shell/raw/master/CentOS/set_locale.sh)
	bash <(curl -s http://git.oschina.net/x242025/Shell/raw/master/CentOS/history.sh)

	#  install python environment of shaowsocks
	yum install m2crypto python-setuptools -y
	easy_install pip
}



echo -n "Please input the remote kcptun port: "
read remote_kcptun_port

echo -n "Please input kcptun password: "
read kcptun_password

echo -n "Please input kcptun mode: "
read kcptun_mode

echo -n "Please input local shadowsocks port: "
read local_ss_port

echo -n "Please input local shadowsocks password: "
read local_ss_password

echo -n "Please any key to continue or CTRL + C to pause..."
read opt


install_dep
pip install shadowsocks
git clone https://github.com/xingtingyang/kcss.git
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

sudo chmod a+x -R $script_path
sudo $script_path/kcss.sh start
sudo echo "$script_path/kcss.sh start" >> /etc/rc.local








