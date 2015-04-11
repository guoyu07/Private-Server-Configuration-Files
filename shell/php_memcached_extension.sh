# http://www.94cb.com/t/2428
# Author: Canbin Lin
# libmemcached
wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
tar -zxvf libmemcached-1.0.18.tar.gz 
cd libmemcached-1.0.18 
./configure -prefix=/usr/local/libmemcached -with-memcached 
make && make install
# php-devel
yum install php-devel
# memcached extension
wget http://pecl.php.net/get/memcached-2.2.0.tgz 
tar -zxvf memcached-2.2.0.tgz 
cd memcached-2.2.0 
/www/wdlinux/apache_php/bin/phpize 
./configure -enable-memcached -with-php-config=/www/wdlinux/apache_php/bin/php-config -with-zlib-dir -with-libmemcached-dir=/usr/local/libmemcached -prefix=/usr/local/phpmemcached -disable-memcached-sasl
make && make install
# php.ini
grep -q 'memcache.so' /www/wdlinux/etc/php.ini
if [ $? != 0 ]; then
    echo "
[memcached]
memcached.extension_dir = /www/wdlinux/apache_php-5.6.5/lib/php/extensions/no-debug-non-zts-20131226/
extension = memcached.so" >> /www/wdlinux/etc/php.ini
fi