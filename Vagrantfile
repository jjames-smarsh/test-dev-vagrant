Vagrant.configure(2) do |config|
  boxes = [
    { :name => "devubu6", :box => "ubuntu/trusty64", :ip => "192.168.0.2" },
    { :name => "devcnt7", :box => "generic/centos7", :ip => "192.168.0.3" },
    { :name => "devcnt6", :box => "generic/centos6", :ip => "192.168.0.4" }    
  ]

  ###
  # Windows Test Boxes
  ###
  window_boxes = [
    { :name => "serv2016", :box => "mwrock/Windows2016", :ip => "192.168.0.5" },
    { :name => "serv2019", :box => "trueability/windows-server-2019", :ip => "192.168.0.6" }
  ]

  config.vm.define "ansible" do |ansible|
    ansible.vm.box = "ubuntu/trusty64"
    ansible.vm.provision "shell", path: "scripts/install.sh"

    ansible.vm.network "private_network", ip: "192.168.0.254"
    ansible.vm.hostname = "ansible"
  end


## Window Test Box Generation
  window_boxes.each { |opts|
    config.vm.define opts[:name] do |dev|
      dev.vm.box = opts[:box]      
      dev.vm.provision "shell", path: "scripts/ConfigureRemotingForAnsible.ps1"
      dev.vm.provision "ansible" do |ansible|
        # ansible.inventory_path = "inventory.txt"
        # ansible.groups = {
        #   "windows" => ["serv2019"]
        # }
        ansible.playbook = "windows_playbook.yml"
      end
      dev.vm.provision :serverspec do |spec|
        # pattern for specfiles to search
        spec.pattern = '*_spec.rb'
        # pattern for specfiles to ignore, similar to rspec's --exclude-pattern option
        spec.exclude_pattern = 'but_not_*_spec.rb'
      end
      dev.vm.guest = :windows
      dev.vm.communicator = "winrm"
      dev.vm.network "forwarded_port", guest: 3390, host: 3390
      dev.vm.network "private_network", ip: opts[:ip]
      dev.vm.hostname = opts[:name]
    end
  } 
    
###
# Linux Test Box Generation
###
  boxes.each { |opts|
    config.vm.define opts[:name] do |dev|
      dev.vm.box = opts[:box]      
      dev.vm.provision "shell", path: "scripts/base_install.sh"
      dev.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
      end
      dev.vm.provision :serverspec do |spec|
        # pattern for specfiles to search
        spec.pattern = '*_spec.rb'
        # pattern for specfiles to ignore, similar to rspec's --exclude-pattern option
        spec.exclude_pattern = 'but_not_*_spec.rb'
      end
      dev.vm.network "private_network", ip: opts[:ip]
      dev.vm.hostname = opts[:name]
    end
  }


end