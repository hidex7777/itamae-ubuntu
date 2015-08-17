package 'tree' do
  action :install
  user 'root'
end


package 'git'

RBENV_DIR = "/home/vagrant/.rbenv"
BASH_RC = "/home/vagrant/.bashrc"

git RBENV_DIR do
  repository "git://github.com/sstephenson/rbenv.git"
  user 'vagrant'
end

git "#{RBENV_DIR}/plugins/ruby-build" do
  repository "git://github.com/sstephenson/ruby-build.git"
  user 'vagrant'
end

remote_file '/home/vagrant/.bashrc' do
  mode '644'
  owner 'vagrant'
  group 'vagrant'
end

execute "install ruby 2.2.2" do
  command "source #{BASH_RC}; rbenv install 2.2.2"
  not_if "rbenv versions | grep 2.2.2"
end

execute "set global ruby" do
  command "source #{BASH_RC}; rbenv global 2.2.2; rbenv rehash"
  not_if "rbenv global | grep 2.2.2"
end

execute "gem install gems" do
  command "source #{BASH_RC}; gem install bundler; rbenv rehash"
  not_if "gem list | grep bundler"
end

