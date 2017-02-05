#!/bin/bash

pp=`dir "$0"`
nohup sslocal -c $pp/single-shadowsocks.json > /dev/null 2>&1 & 
