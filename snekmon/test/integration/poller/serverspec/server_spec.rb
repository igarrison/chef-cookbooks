require 'spec_helper'

describe 'snekmon.py should be configured per node attributes' do
  describe file('/usr/local/bin/snekmon.py') do
    it { should be_file }
    its(:content) { should match(/CARBON_SERVER = '10.10.10.10'/) }
    its(:content) { should match(/CARBON_PORT = 2003/) }
    its(:content) { should match(/DELAY = 60/) }
  end
end

describe 'snekmon::poller logs as the "nobody" user' do
  describe command('grep nobody /etc/passwd') do
    its(:stdout) { should match(/nobody/) }
  end
end

