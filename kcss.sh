#!/bin/bash


function stop(){
    kcptun_id=`ps -A |grep server_linux| awk '{print $1}'`
    kill $kcptun_id
    shadowsocks_id=`ps -A |grep ssserver| awk '{print $1}'`
    kill $shadowsocks_id
    echo 'successfully stop kcptun and shadowsocks server...'
}

function start(){
    pp=`dirname "$0"`
    nohup ssserver -c $pp/shadowsocks.json > /dev/null 2>&1 &
    nohup $pp/server_linux_amd64 -c $pp/kcptun.json > /dev/null 2>&1 &
    echo 'successfully start kcptun and shadowsocks server...'
}


case "$1" in 
	
	start)
		start
		;;

	stop)
		stop
		;;

	restart)
		stop
		start
		;;

	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
		;;

esac

exit 0
