group 'marcelo' do
    action :create
  end
  
  user 'marcelo' do
    manage_home true
    comment 'Default User'
    uid '1000'
    gid 'marcelo'
    home '/home/marcelo'
    shell '/bin/bash'
    password 'Hashiconf2019'
  end

  sudo 'marcelo' do
    user 'marcelo'
    nopasswd true
  end
  
  directory '/home/marcelo/.ssh' do
    owner 'marcelo'
    group 'marcelo'
    mode '0700'
    action :create
  end
  
  file '/home/marcelo/.ssh/authorized_keys' do
    owner 'marcelo'
    group 'marcelo'
    mode '0644'
    content 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRSvh/mi3dOsMRJA0wHB77x+LbFYzTFXc8b2LYeSAMqa06dYC8p9YpmM36dlZ353x8/cDsUEMoiCRUmWuiTEbUHZXvKaBdZiNqdPEed7+05KNWn8WsbKS7PSgAPOIvhS2Cq9WA0hHsxm+GA6bzT4AYMkdSbg4E6Xsisn8f9lT+vJRNmfX+pO4ziIqmX+QM1SmJR5uyiZcSKijIba5qfG1aT6Hxxl7IHjQowtFIevH65krHS0USHqxKwe3Qi5fY+LZC29RW8M6b6UpPICcPdzEtWdrJ2ZdKKtXIK+rL0pZFjqBO1WISweuHnsN58axNUQmSqZkAqjRWBAalpewnWzcTTOjjHUYyiVy2R9QgU+oULunVYZ31/B9uIcmpPyno0D9jMnILK14mUXAfmTPBiiSC25Hsd5jy+x02tj1CNfvddAqrwzbtgsa/nR3mKvXozRGsHf5Y2LG+n3OLITEdAjY0bjAPfvATbwmk9cXx4HDOeGe2EOXTr0ZGU5NTHYnWydgMtNqCeL+10MYYT2NbyZTQ4cu0F9xLdj1sIqjQIWubTocsprec6Zb7PZCTjhwXTDxJcTMAOs+qi4/T4zXlzDvrLAjBTmE91yUPPrt7B0ZVvI+X/G42eahprGO5G0vD1fRfg9KgucZgBZ3WDvuZWHveZVYdo4kTLoj1L72DfiE6TQ=='
  end
  
  ruby_block 'sshd_config' do
    block do
      fe = Chef::Util::FileEdit.new('/etc/ssh/sshd_config')
      fe.search_file_delete_line(/PasswordAuthentication/)
      fe.insert_line_if_no_match(/PasswordAuthentication/, 'PasswordAuthentication no')
      fe.write_file
    end
    not_if 'cat /etc/ssh/sshd_config | grep "PasswordAuthentication no"'
  end
  