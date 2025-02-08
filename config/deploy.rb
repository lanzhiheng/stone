# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "stone"
set :repo_url, "git@github.com:lanzhiheng/stone.git"
set :rbenv_ruby, File.read('.ruby-version').strip
set :app_url, 'https://www.lanzhiheng.com'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :sitemap_roles, :web
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/stone"

# https://github.com/capistrano/capistrano/issues/1884

set :default_env, { 'BASH_ENV' => "/home/lan/.bashrc"}

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  task :stop do
    # Do nothing.
  end

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      # execute "service nginx restart"
      invoke "puma:restart"
    end
  end

  desc "Start application"
  task :start do
    on roles(:app) do
      invoke "puma:start"
    end
  end

  desc "Stop application"
  task :stop do
    on roles(:app) do
      invoke "puma:stop"
    end
  end

  after :publishing, :restart

  desc 'Visit the app'
  task :visit_web do
    system "open #{fetch(:app_url)}"
  end

  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app) do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
      end
    end

    before :linked_files, :set_database_configuration do
      on roles(:app) do
        unless test("[ -f #{shared_path}/config/database.yml ]")
          upload! 'config/database.yml', "#{shared_path}/config/database.yml"
        end
      end
    end
  end
end

# For safety, override the db:push operation from capistrano-db-tasks
Rake::Task["db:remote:sync"].clear_actions

namespace :db do
  namespace :remote do
    desc 'Synchronize your local database using remote database data'
    task :sync do
      system "echo 'This operation has been disabled.'"
    end
  end
end

after 'deploy:restart', 'sitemap:refresh'
after 'deploy:restart', 'deploy:visit_web'

append :linked_files, 'config/database.yml', 'config/master.key'
append :linked_dirs, "tmp", "public", ".bundle", "log", "node_modules"
