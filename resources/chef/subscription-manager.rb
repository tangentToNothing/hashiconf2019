# install subscription-manager
# file "/etc/yum.repos.d/centos-deps.repo" do
# content IO.read("/tmp/centos-deps.repo")
# end

# install EPEL
remote_file "/tmp/epel.rpm" do
    source "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm" 
end

yum_package "epel_config" do
    source "/tmp/epel.rpm"
end