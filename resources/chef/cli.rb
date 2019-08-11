# install both cloud CLIs
yum_package "awscli"
yum_package "azure-cli" do
options '--nogpgcheck'
end
