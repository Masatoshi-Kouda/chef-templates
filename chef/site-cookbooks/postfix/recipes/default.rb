package "sendmail" do
  action :remove
end

%w{
postfix
cyrus-sasl-plain
}.each do |pkg|
  package pkg do
    action :install
  end
end

service "postfix" do
  action [ :enable, :start ]
  supports :start => true, :status => true, :restart => true, :reload => true
end

template "/etc/postfix/main.cf" do
  source "main.cf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, 'service[postfix]'
end
