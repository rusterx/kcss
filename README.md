# KCSS使用说明

使用时，先安装git，并使用如下命令将所有文件下载到本地

```
git clone https://github.com/xingtingyang/kcss.git
```

## server
运行服务端的配置文件，并按照要求输入参数

```
bash kcss/server-config.sh
```


## client
在服务器中执行以下命令，生成客户端的配置文件，并将客户端的压缩包下载到本地，然后运行`kcss.sh`或者`single-shadowsocks.sh`文件即可。

- 在服务器中生成客户端配置文件
```bash
bash kcss/client-config.sh
```

- 在本地安装shadowsocks
```bash
yum install m2crypto python-setuptools -y
easy_install pip
pip install shadowsocks
```

- 在本地下载客户端配置文件
```bash
# http://www.cnblogs.com/3me-linux/p/4284931.html
server_ip=`curl -s ident.me`
wget http://${server_ip}:8000/kcss-client.tar.gz
tar -xvf kcss-client.tar.gz
bash kcss-client/kcss.sh start
# bash kcss-client/single-shadowsocks.sh
```

如果需要配置自启动，请将相关命令写入`/etc/rc.local`文件中