execute "docker install" do
  command "curl -sSL #{node['docker']['url_path']} | sh"
  not_if "rpm -qa | grep -q docker-engine"
end

service "docker" do
  action [:enable, :start]
end

node['docker']['groups'].each do |group|
  group "docker" do
    action :modify
    members "#{group}"
  end
end
