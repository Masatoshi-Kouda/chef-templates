template "/etc/httpd/conf.d/zabbix.conf" do
  source "zabbix.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :domain => node['apache2']['domain']
  })
  notifies :restart, 'service[httpd]'
end
