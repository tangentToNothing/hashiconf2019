# init steps for config
execute "set hostname" do
    command "hostnamectl set-hostname derp.com"
end

# set users , directories, etc here