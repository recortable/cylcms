require 'yaml'
GIT = YAML.load_file("#{File.dirname(__FILE__)}/git.yml")

default_run_options[:pty] = true
set :application, "cylcms"
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

after "deploy:update_code", "config:copy_shared_configurations"
after "deploy", "deploy:cleanup"

namespace :deploy do
  task :start do
  end
  task :stop do
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :config do
  desc "copy shared configurations to current"
  task :copy_shared_configurations, :roles => [:app] do
    %w[database.yml pusher.yml].each do |f|
      run "ln -nsf #{shared_path}/config/#{f} #{release_path}/config/#{f}"
    end
  end
end
