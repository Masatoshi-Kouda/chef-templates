%w{
gcc
make
readline-devel
openssl-devel
libxml2
libxslt
libxml2-devel
libxslt-devel
}.each do |pkg|
  package pkg do
    action :install
  end
end

git "/usr/local/rbenv" do
  repository "#{node['ruby']['rbenv_url']}"
  reference "master"
  action :checkout
  user "root"
  group "root"
end

directory "/usr/local/rbenv/plugins" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

template "/etc/profile.d/rbenv.sh" do
  source "rbenv.sh"
  owner "root"
  group "root"
  mode 0644
end

git "/usr/local/rbenv/plugins/ruby-build" do
  repository "#{node['ruby']['ruby-build_url']}"
  reference "master"
  action :checkout
  user "root"
  group "root"
end

bash "ruby install" do
  code <<-EOC
    source /etc/profile.d/rbenv.sh
    rbenv install #{node['ruby']['version']}
    rbenv global #{node['ruby']['version']}
    rbenv rehash
  EOC
  action :run
  not_if "source /etc/profile.d/rbenv.sh ; rbenv versions | grep #{node['ruby']['version']}"
end

gem_package "bundler" do
  gem_binary '/usr/local/rbenv/shims/gem'
  action :install
end
