execute "hostname-setting" do
  command "hostname #{node[:host_name]}"
  action :nothing
end

service "rsyslog" do
  action [ :enable, :start]
end

if node['platform_version'].to_i == 6 || node["platform"] == "amazon"
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
elsif node['platform_version'].to_i == 7
  template "/etc/hostname" do
    source "hostname.erb"
    mode 0644
    owner "root"
    group "root"
    variables({
      :hostname => node[:host_name]
    })
    notifies :run,"execute[hostname-setting]",:immediately
    notifies :restart, 'service[rsyslog]'
  end
end
