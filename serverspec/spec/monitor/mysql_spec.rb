require 'spec_helper'

%w{
MySQL-client
MySQL-server
MySQL-devel
MySQL-shared-compat
MySQL-shared
}.each do |pkg|
  describe package("#{pkg}") do
    it { should be_installed }
  end
end

describe service('mysql') do
  it { should be_enabled }
  it { should be_running }
end

describe port(3306) do
  it { should be_listening }
end
