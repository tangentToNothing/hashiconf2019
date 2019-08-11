# init steps for config
execute "set hostname" do
    command "hostnamectl set-hostname derp.com"
end

user 'zzadmin'

directory '/home/zzadmin' do
    owner 'zzadmin'
    group 'zzadmin'
end