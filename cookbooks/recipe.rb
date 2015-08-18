package 'tree' do
  action :install
  user 'root'
end

package 'git'

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

