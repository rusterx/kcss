# kcss使用说明

> 使用本仓库，可以非常自由简单的部署kcptun+shadowsocks组合。

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

如果需要配置自启动，请将相关命令写入`/etc/rc.local`文件中, 想要将socks5代理转换成http代理，则需要安装polipo或者privoxy

## 安装并配置polipo或者privoxy
一般来说，privoxy和polipo在ubuntu中可以直接安装，而在centos中是不可以的。在centos中建议使用privoxy

- 安装privoxy
```bash
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
yum install privoxy -y
```

- 更新privoxy
```bash
yum update privoxy -y
```

- 配置privoxy

配置文件路径`/usr/local/etc/privoxy/config`， 找到如下配置，并修改

```bash
enable-remote-toggle 1
enable-remote-http-toggle 1
```

```bash
# 将forward-socks5的行改成，注意后边的点
forward-socks5 / 127.0.0.1:1080 .
```

- 使用alias简化代理使用过程

以后使用只要使用`set_proxy`命令即可，使用`unset_proxy`即可不用代理
```
echo 'alias set_proxy="export http_proxy=http://127.0.0.1:8118 && export https_proxy=http://127.0.0.1:8118"' >> ~/.bash_profile
echo 'alias unset_proxy="unset http_proxy && unset https_proxy"' >> ~/.bash_profile
source ~/.bash_profile
```




