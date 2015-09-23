package "java-1.8.0-openjdk" do
  action :install
end

execute "jenkins-repo install" do
  command "wget -O #{node['jenkins']['repo']} #{node['jenkins']['repo_url']}"
  not_if {File.exists?("#{node['jenkins']['repo']}")}
end

execute "jenkins-repo install" do
  command "rpm --import #{node['jenkins']['gpg_url']}"
  not_if "rpm -qa | grep -q #{node['jenkins']['gpg_key']}"
end

package "jenkins" do
  action :install
  options "--enablerepo=jenkins"
end

service "jenkins" do
  action [:enable, :start]
end

