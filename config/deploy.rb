require "bundler/capistrano"

set :application, "hncsd"
set :app_user, "hncsd"

set :scm, :git
set :branch, "master"
set :repository,  "git://github.com/mangege/hncsd.git"
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{app_user}/apps/#{application}"

#set :use_sudo, true
#set :admin_runner, "#{app_user}"
#set :runner, "#{app_user}"
set :use_sudo, false
default_run_options[:pty] = true
#set :rcfile, ::File.expand_path("./config/rcfile", release_path)
default_run_options[:shell] = "cd /tmp; sudo -u #{app_user} bash --rcfile /etc/app.rcfile -i"


role :web, "h-jm.mangege.com"                          # Your HTTP server, Apache/etc
role :app, "h-jm.mangege.com"                          # This may be the same as your `Web` server
role :db,  "h-jm.mangege.com", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
