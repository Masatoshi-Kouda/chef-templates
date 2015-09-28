execute "hostname-setting" do
  command "hostname #{node[:host_name]}"
  action :nothing
end

template "/etc/sysconfig/network" do
  source "network.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :hostname => node[:host_name]
  })
  notifies :run,"execute[hostname-setting]",:immediately
  notifies :restart, 'service[rsyslog]'
end

