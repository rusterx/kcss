#!/bin/bash

function read_server_config(){
	remote_kcptun_port=`echo ${kcptun_json} | ${jq_path} -r '.listen'|cut -c2-`
	local_ss_port=`echo ${kcptun_json} | ${jq_path} -r '.target'|cut -c11-`
	kcptun_password=`echo ${kcptun_json} | ${jq_path} -r '.key'`
	kcptun_mode=`echo ${kcptun_json} | ${jq_path} -r '.mode'`

	local_ss_password=`echo ${ss_json} | ${jq_path} -r '.password'`
	server_ip=`curl -s ipinfo.io | ${jq_path} -r '.ip'`
}


pp=`pwd`
server_path="${pp}/kcss-server"

jq_dirname="${pp}/jq";
jq_path="${jq_dirname}/jq-linux64"
kcptun_json=`cat ${server_path}/kcptun.json`
ss_json=`cat ${server_path}/shadowsocks.json`

read_server_config

ss_base4_config=`echo aes-256-cfb:${local_ss_password}@${server_ip}:${local_ss_port}|base64`
ss_config="ss://${ss_base4_config}"
wget "http://qr.liantu.com/api.php?text=${ss_config}" -O ${server_path}/ss-qr.png

kcptun_config="-autoexpire 60 -key \"${kcptun_password}\" -mode \"fast2\""
wget "http://qr.liantu.com/api.php?text=${kcptun_config}" -O ${server_path}/kcptun-qr.png

clear
echo "kcptun remote port is: ${remote_kcptun_port}"
echo "http://${server_ip}:8000/kcss-server/ss-qr.png"
echo "http://${server_ip}:8000/kcss-server/kcptun-qr.png"
python -m SimpleHTTPServer

