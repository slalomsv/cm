package  'mysql-server' do
  action :install
end

mysql_service 'simple' do
  port '3306'
  initial_root_password 'change_me'
  action [:create, :start]
end
