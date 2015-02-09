require 'spec_helper'

describe 'snekmon-poller.py should be configured per node attributes' do
  describe file('/usr/local/bin/snekmon-poller.py') do
    it { should be_file }
    its(:content) { should match(/CARBON_SERVER = '10.10.10.10'/) }
    its(:content) { should match(/CARBON_PORT = 2003/) }
    its(:content) { should match(/DELAY = 60/) }
  end
end

describe 'snekmon-poller.py should be logging' do
  describe file('/var/log/snekmon/current') do
    it { should be_file }
    its(:content) { should match(/Starting snekmon-poller.py/) }
  end
end
