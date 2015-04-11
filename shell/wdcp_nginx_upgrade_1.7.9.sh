#!/bin/bash
# nginx update scripts
# http://www.94cb.com/t/2448
if [ ! $1 ];then
    ver="1.7.9"
else
    ver=$1
fi
cd /tmp
wget http://down.wdlinux.cn/in/pcre_ins.sh
sh pcre_ins.sh
wget -c http://nginx.org/download/nginx-$ver.tar.gz
[ $? != 0 ] && echo "down err" && exit
tar zxvf nginx-$ver.tar.gz
cd nginx-$ver
./configure --user=www --group=www --prefix=/www/wdlinux/nginx-$ver --with-http_stub_status_module --with-http_ssl_module --with-ipv6
[ $? != 0 ] && echo "configure err" && exit
make
[ $? != 0 ] && echo "make err" && exit
make install
[ $? != 0 ] && echo "make install err" && exit
mv /www/wdlinux/nginx-$ver/conf/nginx.conf /www/wdlinux/nginx-$ver/conf/nginx.conf.default
cp -pR /www/wdlinux/nginx/conf/* /www/wdlinux/nginx-$ver/conf/
service nginxd stop
rm -f /www/wdlinux/nginx
ln -sf /www/wdlinux/nginx-$ver /www/wdlinux/nginx
sed -i '/limit_zone/d' /www/wdlinux/nginx/conf/nginx.conf
service nginxd start
echo
echo
echo "nginx Update Is OK"
echo "Current Ver Is:$ver"
echo