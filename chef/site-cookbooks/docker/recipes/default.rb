execute "docker install" do
  command "curl -sSL #{node['docker']['url_path']} | sh"
  not_if "rpm -qa | grep -q docker-engine"
end

service "docker" do
  action [:enable, :start]
end

group "docker" do
  action :modify
  members ['vagrant']
  append true
end
