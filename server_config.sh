#!/bin/bash

# install dependencies
function install_dep(){
	yum install m2crypto python-setuptools -y
	easy_install pip
}

# read config parameters
function read_param(){
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
}


install_dep && read_param
pip install shadowsocks

pp=`dirname "$0"`
server_script_path="${pp}/kcss-server"

cat > ${server_script_path}/shadowsocks.json << EOF
{
    "server":"::0",  
    "server_port":${local_ss_port},  
    "local_port":1080,  
    "password":"${local_ss_password}",  
    "timeout":600,  
    "method":"aes-256-cfb"
}
EOF

cat > ${server_script_path}/kcptun.json << EOF
{
    "listen": ":${remote_kcptun_port}",
    "target": "127.0.0.1:${local_ss_port}",
    "key": "${kcptun_password}",
    "mode": "${kcptun_mode}"
}
EOF

chmod -R 777 ${server_script_path}
bash ${server_script_path}/kcss.sh start
echo "${server_script_path}/kcss.sh start" >> /etc/rc.local








