require 'yaml'
GIT = YAML.load_file("#{File.dirname(__FILE__)}/git.yml")

default_run_options[:pty] = true
set :application, "laogen"
set :deploy_to, "/home/deploy/#{application}"
set :user, "deploy"
set :use_sudo, false

set :scm, "git"
set :repository,  "git://github.com/danigb/laogen.es.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :scm_verbose, true
set :scm_passphrase, GIT['password']

role :app, "toami.net"
role :web, "toami.net"
role :db,  "toami.net", :primary => true

namespace :deploy do
  task :start {}
  task :stop {}
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
