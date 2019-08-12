# configure image for operation in Azure
# grub entry
ruby_block 'grub_modifications' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/default/grub')
        fe.search_file_delete_line(/GRUB_CMDLINE_LINUX/)
        fe.insert_line_if_no_match(/GRUB_CMDLINE_LINUX/, 'GRUB_CMDLINE_LINUX="rootdelay=300 console=ttyS0 earlyprintk=ttyS0 net.ifnames=0"')
        fe.write_file
    end
    not_if 'cat /etc/default/grub | grep "rootdelay=300 console=ttyS0 earlyprintk=ttyS0 net.ifnames=0"'
end
    
execute 'rebuild_grub' do
    command "grub2-mkconfig -o /boot/grub2/grub.cfg"
end
    
yum_package "udftools"
    
# dracut entry
ruby_block 'grub_modifications' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/dracut.conf')
        fe.search_file_delete_line(/add_drivers/)
        fe.insert_line_if_no_match(/add_drivers/, 'add_drivers+=”hv_vmbus hv_netvsc hv_storvsc”')
        fe.write_file
    end
    not_if 'cat /etc/dracut.conf | grep "add_drivers+=”hv_vmbus hv_netvsc hv_storvsc”"'
end

execute "rebuild_initramfs" do
    command "dracut -f -v"
end

# networking
file "/etc/sysconfig/network" do
    action :create_if_missing
end
    
file "/etc/sysconfig/network-scripts/ifcfg-eth0" do
    action :create_if_missing
end
    
file "/etc/modprobe.d/udf.conf" do
    action :create_if_missing
end
    
# execute "install_udf" do
#     command "echo 'install udf /bin/true' > /etc/modprobe.d/udf.conf"
# end
    
ruby_block 'sysconfig_network_1' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/sysconfig/network')
        fe.search_file_delete_line(/NETWORKING/)
        fe.insert_line_if_no_match(/NETWORKING/, 'NETWORKING=yes')
        fe.write_file
    end
    not_if 'cat /etc/sysconfig/network | grep NETWORKING=yes'
end
    
ruby_block 'sysconfig_network_2' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/sysconfig/network')
        fe.search_file_delete_line(/HOSTNAME/)
        fe.insert_line_if_no_match(/HOSTNAME/, 'HOSTNAME=localhost.localdomain')
        fe.write_file
    end
    not_if 'cat /etc/sysconfig/network | grep HOSTNAME=localhost.localdomain'
end
    
ruby_block 'eth0_config_1' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/sysconfig/network-scripts/ifcfg-eth0')
        fe.search_file_delete_line(/DEVICE/)
        fe.insert_line_if_no_match(/DEVICE/, 'DEVICE=eth0')
        fe.write_file
    end
    not_if 'cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep DEVICE=eth0'
end
    
ruby_block 'eth0_config_2' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/sysconfig/network-scripts/ifcfg-eth0')
        fe.search_file_delete_line(/ONBOOT/)
        fe.insert_line_if_no_match(/ONBOOT/, 'ONBOOT=yes')
        fe.write_file
    end
    not_if 'cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep ONBOOT=yes'
end
    
ruby_block 'eth0_config_3' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/sysconfig/network-scripts/ifcfg-eth0')
        fe.search_file_delete_line(/BOOTPROTO/)
        fe.insert_line_if_no_match(/BOOTPROTO/, 'BOOTPROTO=dhcp')
        fe.write_file
    end
    not_if 'cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep BOOTPROTO=dhcp'
end
    
ruby_block 'eth0_config_4' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/sysconfig/network-scripts/ifcfg-eth0')
        fe.search_file_delete_line(/TYPE/)
        fe.insert_line_if_no_match(/TYPE/, 'TYPE=Ethernet')
        fe.write_file
    end
    not_if 'cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep TYPE=Ethernet'
end
    
ruby_block 'eth0_config_5' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/sysconfig/network-scripts/ifcfg-eth0')
        fe.search_file_delete_line(/USERCTL/)
        fe.insert_line_if_no_match(/USERCTL/, 'USER6CTL=no')
        fe.write_file
    end
    not_if 'cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep USERCTL=no'
end
    
ruby_block 'eth0_config_6' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/sysconfig/network-scripts/ifcfg-eth0')
        fe.search_file_delete_line(/PEERDNS/)
        fe.insert_line_if_no_match(/PEERDNS/, 'PEERDNS=yes')
        fe.write_file
    end
    not_if 'cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep PEERDNS=yes'
end
    
ruby_block 'eth0_config_7' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/sysconfig/network-scripts/ifcfg-eth0')
        fe.search_file_delete_line(/IPV6INIT/)
        fe.insert_line_if_no_match(/IPV6INIT/, 'IPV6INIT=no')
        fe.write_file
    end
    not_if 'cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep IPV6INIT=no'
end
    
ruby_block 'eth0_config_8' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/sysconfig/network-scripts/ifcfg-eth0')
        fe.search_file_delete_line(/NM_CONTROLLED/)
        fe.insert_line_if_no_match(/NM_CONTROLLED/, 'NM_CONTROLLED=no')
        fe.write_file
    end
    not_if 'cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep NM_CONTROLLED=no'
end
    
execute "fix_eth0" do
    command "ln -s /dev/null /etc/udev/rules.d/75-persistent-net-generator.rules"
end
    
# azure packages
yum_package "python-pyasn1"
yum_package "WALinuxAgent"
    
# config azure package
ruby_block 'config_azure_service_1' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/waagent.conf')
        fe.search_file_delete_line(/ResourceDisk.Format/)
        fe.insert_line_if_no_match(/ResourceDisk.Format/, 'ResourceDisk.Format=y')
        fe.write_file
    end
    not_if 'cat /etc/waagent.conf | grep ResourceDisk.Format=y'
end
    
ruby_block 'config_azure_service_2' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/waagent.conf')
        fe.search_file_delete_line(/ResourceDisk.Filesystem/)
        fe.insert_line_if_no_match(/ResourceDisk.Filesystem/, 'ResourceDisk.Filesystem=xfs')
        fe.write_file
    end
    not_if 'cat /etc/waagent.conf | grep ResourceDisk.Filesystem=xfs'
end
    
ruby_block 'config_azure_service_3' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/waagent.conf')
        fe.search_file_delete_line(/ResourceDisk.MountPoint/)
        fe.insert_line_if_no_match(/ResourceDisk.MountPoint/, 'ResourceDisk.MountPoint=/mnt/resource')
        fe.write_file
    end
    not_if 'cat /etc/waagent.conf | grep ResourceDisk.MountPoint=/mnt/resource'
end
    
ruby_block 'config_azure_service_4' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/waagent.conf')
        fe.search_file_delete_line(/ResourceDisk.EnableSwap/)
        fe.insert_line_if_no_match(/ResourceDisk.EnableSwap/, 'ResourceDisk.EnableSwap=y')
        fe.write_file
    end
    not_if 'cat /etc/waagent.conf | grep ResourceDisk.EnableSwap=y'
end
    
ruby_block 'config_azure_service_5' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/waagent.conf')
        fe.search_file_delete_line(/ResourceDisk.SwapSizeMB/)
        fe.insert_line_if_no_match(/ResourceDisk.SwapSizeMB/, 'ResourceDisk.SwapSizeMB=2048')
        fe.write_file
    end
    not_if 'cat /etc/waagent.conf | grep ResourceDisk.SwapSizeMB=2048'
end
    
# enable azure service 
service "waagent" do
    action [:enable, :start]
end
    
execute "waagent_deprov" do
    command "waagent -force -deprovision"
end
    
execute "histsize_zero" do
    command "export HISTSIZE=0"
end