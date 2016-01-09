require 'spec_helper'

%w{
OpenIPMI-libs
fping
net-snmp
unixODBC
vlgothic-p-fonts
iksemel
php-bcmath
zabbix-server-mysql
zabbix-web-mysql
zabbix-web-japanese
zabbix-get
zabbix-agent
}.each do |pkg|
  describe package("#{pkg}") do
    it { should be_installed }
  end
end

describe service('zabbix-server') do
  it { should be_enabled }
  it { should be_running }
end

describe service('zabbix-agent') do
  it { should be_enabled }
  it { should be_running }
end

describe port(10050) do
  it { should be_listening }
end

describe port(10051) do
  it { should be_listening }
end
