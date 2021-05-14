
require_relative 'spec_helper'
sleep 5
puts "OS Family: #{os[:family]}"
puts `hostname`

if os[:family] == 'redhat'
  describe yumrepo('epel') do
    it { should exist }
    it { should be_enabled }
  end
elsif ['debian', 'ubuntu'].include?(os[:family])
    # debian related environment spec
end


describe file('/etc/passwd') do
  it { should be_file }
  it { should exist }
end

describe service('sshd') do
  it { should be_running }
end

if ['redhat'].include?(os[:family])
    if os[:release].to_f < 7
        describe service('autofs') do
          it { should be_enabled }
          it { should be_running }
        end
    else 
        describe service('autofs.service') do
          it { should be_enabled }
          it { should be_running }
        end
    end
    if os[:family] == 'ubuntu'
        describe service('autofs') do
            it { should be_enabled }
            it { should be_running }
        end
    end
end


