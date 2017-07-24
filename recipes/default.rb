# mysql-server failed to install without updates
apt_update 'update' do
  action :update
end

include_recipe 'cm::mysql'
include_recipe 'cm::simple_app'
