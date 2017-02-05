#!/bin/bash

function read_server_config(){
	remote_kcptun_port=`echo ${kcptun_json} | ${jq_path} -r '.listen'|cut -c2-`
	local_ss_port=`echo ${kcptun_json} | ${jq_path} -r '.target'|cut -c11-`
	kcptun_password=`echo ${kcptun_json} | ${jq_path} -r '.key'`
	kcptun_mode=`echo ${kcptun_json} | ${jq_path} -r '.mode'`

	local_ss_password=`echo ${ss_json} | ${jq_path} -r '.password'`
	server_ip=`curl -s ipinfo.io | ${jq_path} -r '.ip'`
}


pp=`dirname "$0"`
server_path="${pp}/kcss-server"
client_path="${pp}/kcss-client"

\rm -r ${client_path}/*.json
\rm -r *.gz

jq_dirname="${pp}/jq";
jq_path="${jq_dirname}/jq-linux64"
kcptun_json=`cat ${server_path}/kcptun.json`
ss_json=`cat ${server_path}/shadowsocks.json`

read_server_config

cat > ${client_path}/shadowsocks.json << EOF
{
    "server" : "0.0.0.0",
    "server_port" : ${local_ss_port},
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "${local_ss_password}",
    "method": "aes-256-cfb"
}
EOF

cat > ${client_path}/kcptun.json << EOF
{
    "localaddr": ":${local_ss_port}",
    "remoteaddr": "${server_ip}:${remote_kcptun_port}",
    "key": "${kcptun_password}",
    "mode": "${kcptun_mode}"
}
EOF

cat > ${client_path}/single-shadowsocks.json << EOF
{
    "server" : "${server_ip}",
    "server_port" : ${local_ss_port},
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "${local_ss_password}",
    "method": "aes-256-cfb"
}
EOF

chmod -R 777 ${jq_dirname}
chmod -R 777 ${client_path}

tar -cvzf kcss-client.tar.gz kcss-client 
echo 'Create kcss client config successfully...'
echo "http://${server_ip}:8000/kcss-client.tar.gz"
python -m SimpleHTTPServer
