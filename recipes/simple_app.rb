# install packages
%w(git python).each do |pkg|
  package pkg do
    action :install
  end
end

# pull source for application
git '/usr/src/simple-app' do
  repository 'https://github.com/slalomsv/simple-app.git'
  revision 'master'
  action :sync
end

# this file needs modification(s)
template '/usr/src/simple-app/app.js' do
  owner 'root'
  group 'root'
  mode '0644'
  source 'app.js.erb'
end

# populate db
execute 'populate_db' do
  command 'mysql --password=change_me --socket=/var/run/mysql-simple/mysqld.sock < /usr/src/simple-app/db/setup_db.sql'
end

# Get node
remote_file '/root/node-v6.10.2-linux-x64.tar.gz' do
  source 'https://nodejs.org/dist/v6.10.2/node-v6.10.2-linux-x64.tar.gz'
end
execute 'untar_node' do
  command 'tar xvfz node-v6.10.2-linux-x64.tar.gz'
  cwd '/root'
end

# use node to npm install application
execute 'npm_install' do
  command 'PATH=/root/node-v6.10.2-linux-x64/bin:$PATH npm install'
  cwd '/usr/src/simple-app'
end

execute 'pm2_install' do
  command 'PATH=/root/node-v6.10.2-linux-x64/bin:$PATH npm install pm2 -g'
  cwd '/usr/src/simple-app'
end

execute 'lint' do
  command 'PATH=/root/node-v6.10.2-linux-x64/bin:$PATH ./ci/lint.sh'
  cwd '/usr/src/simple-app'
end

execute 'run_pm2' do
  command 'PATH=/root/node-v6.10.2-linux-x64/bin:$PATH pm2 start app.js'
  cwd '/usr/src/simple-app'
end

execute 'test' do
  command 'PATH=/root/node-v6.10.2-linux-x64/bin:$PATH npm run test'
  cwd '/usr/src/simple-app'
end
