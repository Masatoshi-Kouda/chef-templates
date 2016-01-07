%w{
OpenIPMI-libs
fping
net-snmp
unixODBC
vlgothic-p-fonts
iksemel
}.each do |pkg|
    package pkg do
      action :install
      options "--enablerepo=epel"
  end
end

package "php-bcmath" do
 action :install
   if node["platform"] == "amazon"
     options "--disablerepo=amzn-main --disablerepo=amzn-updates --enablerepo=remi --enablerepo=remi-php56"
   else
     options "--enablerepo=remi --enablerepo=remi-php56"
   end
end

execute "zabbix-release install" do
  command "rpm -ivh #{node['zabbix-server']['url_path']}"
  not_if "rpm -qa | grep -q zabbix-release"
end

%w{
zabbix-server-mysql
zabbix-web-mysql
zabbix-web-japanese
zabbix-get
zabbix-agent
}.each do |pkg|
  package pkg do
    action :install
    if node["platform"] == "amazon"
      options "--disablerepo=amzn-main --disablerepo=amzn-updates --enablerepo=zabbix"
    else
      options "--enablerepo=zabbix"
    end
  end
end

service "zabbix-server" do
  action [ :enable, :start ]
end

directory "/var/lib/zabbix" do
  mode 0755
  owner "zabbix"
  group "zabbix"
  action :create
end

template "/etc/zabbix/zabbix_server.conf" do
  source "zabbix_server.conf.erb"
  mode 0640
  owner "root"
  group "root"
  variables({
    :db_host => node['zabbix-server']['db_host'],
    :db_name => node['zabbix-server']['db_name'],
    :db_user => node['zabbix-server']['db_user'],
    :db_password => node['zabbix-server']['db_password'],
    :db_socket => node['zabbix-server']['db_socket']
  })
  notifies :restart, 'service[zabbix-server]'
end

service "zabbix-agent" do
  action [ :enable, :start ]
end

template "/etc/zabbix/zabbix_agentd.conf" do
  source "zabbix_agentd.conf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, 'service[zabbix-agent]'
end
