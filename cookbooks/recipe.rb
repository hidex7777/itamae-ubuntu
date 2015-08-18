package 'tree' do
  action :install
  user 'root'
end

package 'git'

# for Ruby Environment

%w(autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev).each do |pkg|
  package pkg
end

RBENV_DIR = "/home/vagrant/.rbenv"
PROFILE = "/home/vagrant/.profile"

git RBENV_DIR do
  repository "git://github.com/sstephenson/rbenv.git"
end

git "#{RBENV_DIR}/plugins/ruby-build" do
  repository "git://github.com/sstephenson/ruby-build.git"
end

remote_file '/home/vagrant/.bashrc' do
  mode '644'
  owner 'vagrant'
  group 'vagrant'
end

remote_file '/home/vagrant/.profile' do
  mode '644'
  owner 'vagrant'
  group 'vagrant'
end

execute "install ruby 2.2.2" do
  command ". #{PROFILE}; rbenv install 2.2.2"
  user 'vagrant'
  not_if ". #{PROFILE}; rbenv versions | grep 2.2.2"
end

execute "set global ruby" do
  command ". #{PROFILE}; rbenv global 2.2.2; rbenv rehash"
  user 'vagrant'
  not_if ". #{PROFILE}; rbenv global | grep 2.2.2"
end

execute "gem install gems" do
  command ". #{PROFILE}; gem install bundler; rbenv rehash"
  user 'vagrant'
  not_if ". #{PROFILE}; gem list | grep bundler"
end

# For gitbook(Node.js) Environment
NVM_DIR = "/home/vagrant/.nvm"
git NVM_DIR do
  repository "git://github.com/creationix/nvm.git"
  user 'vagrant'
  not_if "test -d #{NVM_DIR}"
end

execute "checkout" do
  cwd NVM_DIR
  command "git checkout `git describe --abbrev=0 --tags`"
  user 'vagrant'
end

execute "source" do
  command ". #{NVM_DIR}/nvm.sh"
  user 'vagrant'
end

execute "profile" do
  command "echo '. ~/.nvm/nvm.sh' >> #{PROFILE}"
  user 'vagrant'
end

execute "nvm install 0.12" do
  command ". #{NVM_DIR}/nvm.sh; nvm install v0.12.7"
  user 'vagrant'
end
execute "nvm use stable" do
  command ". #{NVM_DIR}/nvm.sh; nvm use v0.12.7"
  user 'vagrant'
end
