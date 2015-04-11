#!/bin/bash
# http://www.94cb.com/t/2288
IN_DIR="/www/wdlinux"
MYS_VER="5.5.27"
if [ ! -f mysql-${MYS_VER}.tar.gz ];then
    wget -c http://dl.wdlinux.cn:5180/soft/mysql-${MYS_VER}.tar.gz
fi
yum install -y cmake
tar zxvf mysql-${MYS_VER}.tar.gz
cd mysql-${MYS_VER}
cmake -DCMAKE_INSTALL_PREFIX=$IN_DIR/mysql-$MYS_VER -DSYSCONFDIR=$IN_DIR/etc -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_SSL=no -DWITH_DEBUG=OFF -DWITH_EXTRA_CHARSETS=complex -DENABLED_PROFILING=ON -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1
[ $? != 0 ] && echo "configure err" && exit
make
[ $? != 0 ] && echo "make err" && exit
make install
[ $? != 0 ] && echo "make install err" && exit
service mysqld stop
if [ ! -d /www/wdlinux/mysql_bk ];then
mkdir -p /www/wdlinux/mysql_bk
cp -pR /www/wdlinux/mysql/var/* /www/wdlinux/mysql_bk
fi
rm -f /www/wdlinux/mysql
ln -sf $IN_DIR/mysql-$MYS_VER /www/wdlinux/mysql
sh scripts/mysql_install_db.sh --user=mysql --basedir=/www/wdlinux/mysql --datadir=/www/wdlinux/mysql/var
chown -R mysql.mysql /www/wdlinux/mysql/var
mv /www/wdlinux/mysql/var/mysql /www/wdlinux/mysql/var/mysqlo
cp -pR /www/wdlinux/mysql_bk/* /www/wdlinux/mysql/var/
cp support-files/mysql.server /www/wdlinux/init.d/mysqld
chmod 755 /www/wdlinux/init.d/mysqld
service mysqld restart
echo
if [ -d /www/wdlinux/mysql-5.1.63 ];then
    ln -sf /www/wdlinux/mysql-5.1.63/lib/mysql/libmysqlclient.so.16* /usr/lib/
fi
sleep 2
sh /www/wdlinux/tools/mysql_wdcp_chg.sh
echo
echo "mysql update is OK"