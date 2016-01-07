package "httpd" do
  action :install
end

service "httpd" do
  action [ :enable, :start ]
end

template "/etc/httpd/conf/httpd.conf" do
  source "httpd.conf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, 'service[httpd]'
end
