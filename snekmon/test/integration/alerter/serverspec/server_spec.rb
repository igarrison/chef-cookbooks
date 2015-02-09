require 'spec_helper'

describe 'snekmon-alerter.py should be configured per node attributes' do
  describe file('/usr/local/bin/snekmon-alerter.py') do
    it { should be_file }
    its(:content) { should match(/HSTOOHOT = 90/) }
    its(:content) { should match(/HSTOOCOLD = 75/) }
    its(:content) { should match(/CSTOOCOLD = 59/) }
    its(:content) { should match(/HUMTOOLOW = 39/) }
    its(:content) { should match(/CSTOOCOLD = 59/) }
    its(:content) { should match(/\/10.10.10.10\//) }
  end
end
