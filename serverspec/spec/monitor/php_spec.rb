require 'spec_helper'

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
  describe package("#{pkg}") do
    it { should be_installed }
  end
end
