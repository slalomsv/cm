platform = node['platform']
version = node['platform_version']

name = if version =~ /^7/ && (platform == 'centos')
         'mariadb-server'
       elsif version =~ /^7/ && (platform == 'oracle')
         'mysql-community-common'
       else
         'mysql-server'
       end

execute 'yum_update' do
  command 'yum update -y'
  only_if { version =~ /^7/ && (platform == 'oracle') }
end

package name do
  action :install
end
if version =~ /^7/ && (platform == 'centos')
  service 'mysql' do
    service_name node['mariadb']['mysqld']['service_name']
    supports restart: true
    action :start
  end
elsif version =~ /^7/ && (platform == 'oracle')
  
else
  mysql_service 'simple' do
    port '3306'
    initial_root_password 'change_me'
    action [:create, :start]
  end
end
