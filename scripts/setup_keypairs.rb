#!/usr/bin/ruby

require 'pty'
require 'expect'

$expect_verbose = true #To see the output of the session
#VERBOSE=nil
def copy_key
	puts "Userid: "
	userid = 'ansible'
        pass = 'ansible'
        begin
            File.open('inventory.txt').each { |i|
		puts "Copying key to #{i}"
		PTY.spawn("ssh-copy-id -i #{userid.chomp}@#{i.chomp}"){ |rscreen, wscreen, pid|
            wscreen.sync = true
            rscreen.sync = true
				if rscreen.expect(/Are/, 1)
				  wscreen.puts('yes')
				  rscreen.expect(/[Pp]assword/)
                  wscreen.puts(pass.chomp)
                  rscreen.expect(/[#$%]/,1)
                else
                  rscreen.expect(/[Pp]assword:/)
				  wscreen.puts(pass.chomp)
                  if rscreen.expect(/[#$%]/,1)
                    puts "Complete...."
                  end
                end
		}
			}
	rescue
	    puts File.exists?('hostfile') ? "hostfile exists." : "the hostfile does not exist"
	end
end