%w{
php
php-opcache 
php-devel 
php-mbstring 
php-mcrypt 
php-mysqlnd 
php-phpunit-PHPUnit 
php-pecl-xdebug 
php-pecl-xhprof
php-gd
}.each do |pkg|
  package pkg do
    action :install
    if node["platform"] == "amazon"
      options "--disablerepo=amzn-main --disablerepo=amzn-updates --enablerepo=remi --enablerepo=remi-php56" 
    else
      options "--enablerepo=remi --enablerepo=remi-php56" 
    end
  end
end

template "/etc/php.ini" do
  source "php.ini"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, 'service[httpd]'
end
