bash 'zabbix_server_setup' do
  code <<-"EOH"
    mysql -u root -p#{node['mysql']['user']['root']} -e "create database zabbix character set utf8;"
    mysql -u root -p#{node['mysql']['user']['root']} -e "grant all privileges on zabbix.* to zabbix@localhost identified by '#{node['mysql']['user']['zabbix']}';"
    mysql -u root -p#{node['mysql']['user']['root']} zabbix < /usr/share/doc/zabbix-server-mysql-2.*/create/schema.sql
    mysql -u root -p#{node['mysql']['user']['root']} zabbix < /usr/share/doc/zabbix-server-mysql-2.*/create/images.sql
    mysql -u root -p#{node['mysql']['user']['root']} zabbix < /usr/share/doc/zabbix-server-mysql-2.*/create/data.sql
  EOH
  action :run
  not_if "mysql -u root -p#{node['mysql']['user']['root']} -D zabbix -e 'show databases;'"
end

