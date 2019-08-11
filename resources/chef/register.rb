
execute 'clear_cache' do
    command 'yum clean all'
    action :nothing
end
    
execute 'list_repos' do
    command 'yum repolist'
    action :nothing
end
    
execute 'yum_update' do
    command "yum update -y"
    action :nothing
end
    