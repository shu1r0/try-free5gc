$name = "ubuntu-free5gc"

# ------------------------------------------------------------
# Description
# ------------------------------------------------------------
$description = <<'EOS'
# Free5GC

user: vagrant
password: vagrant

## References
* https://github.com/free5gc/free5gc/wiki/Installation
EOS


# ------------------------------------------------------------
# install Lubutu Desktop
# ------------------------------------------------------------
$install_lubuntu = <<SCRIPT
sudo apt install -y --no-install-recommends lubuntu-desktop
SCRIPT

# ------------------------------------------------------------
# vagrant configure version 2
# ------------------------------------------------------------
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # vm name
    config.vm.hostname = $name + '.localhost'
    # ubuntu image
    # config.vm.box = 'bento/ubuntu-18.04'
    # config.vm.box = 'bento/ubuntu-20.04'
    config.vm.box = "ubuntu/jammy64"

    # share directory
    config.vm.synced_folder './', '/home/vagrant/share'

    # install package
    config.vm.provision 'shell', path: "scripts/install_pkg.sh"
    # config.vm.provision 'shell', inline: $install_lubuntu

    # config virtual box
    config.vm.provider "virtualbox" do |vb|
        vb.name = $name
        vb.gui = true

        vb.cpus = 2
        vb.memory = "4096"
    
        vb.customize [
            "modifyvm", :id,
            "--vram", "32", 
            "--clipboard", "bidirectional", # clip board
            "--draganddrop", "bidirectional", # drag and drop
            "--ioapic", "on", # enable I/O APIC
            '--graphicscontroller', 'vmsvga',
            "--accelerate3d", "off",
            "--hwvirtex", "on",
            "--nestedpaging", "on",
            "--largepages", "on",
            "--pae", "on",
            '--audio', 'none',
            "--uartmode1", "disconnected",
            "--description", $description
        ]
    end
end
