require "bundler/capistrano"
#load "deploy/assets"

default_environment['PATH'] = '/usr/local/lib/ruby/gems/1.9.1/bin:$PATH'
default_environment['GEM_PATH']= '/usr/local/lib/ruby/gems/1.9.1'


set :rails_env, 'production'
set :branch, 'master'
set :application, 'zzgroup'

default_run_options[:pty] = true
set :normalize_asset_timestamps, false
set :repository, "git@github.com:Agatov/zzgroup.git"  # Your clone URL
set :scm, :git
set :deploy_via, :remote_cache
set :bundle_gemfile,  'Gemfile'
set :deploy_to, "/apps/sites/#{application}"
set :keep_releases, 3
set :unicorn_conf, "#{deploy_to}/shared/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/unicorn/shared/pids/unicorn.pid"


server '188.120.246.84', :app, :web, :db, primary: true
set :location, '188.120.246.84'
set :user, :root

after 'deploy:update_code', 'deploy:bundle_install'
after 'deploy:update_code', 'deploy:configure'
after 'deploy:configure', 'deploy:migrate'
after 'deploy:configure', 'deploy:assets:precompile'
after 'deploy:restart', 'deploy:cleanup'

namespace :deploy do
  task :configure do

    # Database.yml
    run "rm -f #{current_release}/config/database.yml"
    run "ln -s #{deploy_to}/shared/database.yml #{current_release}/config/database.yml"

    # Sphinx.yml
    run "rm -f #{current_release}/config/sphinx.yml"
    run "ln -s #{deploy_to}/shared/sphinx.yml #{current_release}/config/sphinx.yml"

    # tmp dir
    run "rm -rf #{current_release}/tmp"
    run "ln -s #{deploy_to}/tmp/ #{current_release}/"

    # log dir
    run "rm -rf #{current_release}/log"
    run "ln -s #{deploy_to}/log/ #{current_release}/"

    # uploads dir
    run "ln -s #{deploy_to}/uploads/ #{current_release}/public/"
  end

  task :migrate, roles: :db do
    run "cd #{current_release} && RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
  end
  task :bundle_install, :roles => :app do
    run "cd #{release_path} && bundle install"
  end

  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
    run "cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end

  task :start do
    run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end

  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      #from = source.next_revision(current_revision)
      #if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} assets:precompile}
      #else
      #  logger.info "Skipping asset pre-compilation because there were no asset changes"
      #end
    end
  end
end