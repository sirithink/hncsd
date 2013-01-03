require "bundler/capistrano"

set :application, "hncsd"
set :app_user, "hncsd"
set :nginx_user, "nginx"
set :deploy_user, "outman"

set :scm, :git
set :branch, "master"
set :repository,  "git://github.com/mangege/hncsd.git"
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{deploy_user}/apps/#{application}"

#set :use_sudo, true
#set :admin_runner, "#{app_user}"
#set :runner, "#{app_user}"
set :use_sudo, false
default_run_options[:shell] = "bash -l"
default_run_options[:pty] = true
=begin
#set :rcfile, ::File.expand_path("./config/rcfile", release_path)
default_run_options[:shell] = "cd /tmp; sudo -u #{app_user} bash --rcfile /etc/app.rcfile -i"
=end


role :web, "h-jm.mangege.com"                          # Your HTTP server, Apache/etc
role :app, "h-jm.mangege.com"                          # This may be the same as your `Web` server
role :db,  "h-jm.mangege.com", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{deploy_to}/current/; rvmsudo -u #{app_user} bundle exec thin -C config/thin.yml start"
  end

  task :stop, :roles => :app do
    run "cd #{deploy_to}/current/; rvmsudo -u #{app_user} bundle exec thin -C config/thin.yml stop"
  end

  task :restart, :roles => :app do
    run "cd #{deploy_to}/current/; rvmsudo -u #{app_user} bundle exec thin -C config/thin.yml restart"
  end
end

task :init_shared_path, :roles => :app do
  run "mkdir -p #{deploy_to}/shared/config"

  run "mkdir -p #{deploy_to}/shared/tmp"
  %w[cache pids sessions sockets].each do |dir_name|
    run "mkdir -p #{deploy_to}/shared/tmp/#{dir_name}"
  end
end

task :link_shared_files, :roles => :app do
  run "ln -sf #{deploy_to}/shared/config/*.yml #{deploy_to}/current/config/"

  run "rm -rf #{deploy_to}/current/tmp"
  run "ln -sf #{deploy_to}/shared/tmp #{deploy_to}/current/tmp"
end

task :set_home_acl, :roles => :app do
  run "setfacl -m u:#{app_user}:x /home/#{deploy_user}"
  run "setfacl -m u:#{nginx_user}:x /home/#{deploy_user}"
end

task :set_app_acl, :roles => :app do
  #disable other user access
  run "find #{deploy_to} -user #{deploy_user} -type d -print0 | xargs -0 chmod o-rwx"
  run "find #{deploy_to} -user #{deploy_user} -type f -print0 | xargs -0 chmod o-rwx"

  #thin
  run "find #{deploy_to} -user #{deploy_user} -type d -print0 | xargs -0 setfacl -m u:#{app_user}:rwx"
  run "find #{deploy_to} -user #{deploy_user} -type f -print0 | xargs -0 setfacl -m u:#{app_user}:rw"
  #exec file
  run "find #{deploy_to}/shared/bundle/ruby/1.9.1/bin -user #{deploy_user} -type f -print0 | xargs -0 setfacl -m u:#{app_user}:rwx"

  #nginx
  run "find #{deploy_to} -user #{deploy_user} -type d -print0 | xargs -0 setfacl -m u:#{nginx_user}:rx"
  run "find #{deploy_to} -user #{deploy_user} -type f -print0 | xargs -0 setfacl -m u:#{nginx_user}:r"
end

after "deploy:setup", :init_shared_path, :set_home_acl
before "deploy:finalize_update", :link_shared_files
after "deploy:finalize_update", :set_app_acl
