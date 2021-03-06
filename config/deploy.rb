# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

server '3ears.com', roles: %i[web app db], primary: true

set :user, 'textbookdialogues'
set :repo_url, 'git@github.com:abtwal/subtitledtrailer.git'

set :rvm_ruby_version, '2.7.1@subtitledtrailer'

set :puma_threads, [4, 16]
set :puma_workers, 1

set :pty, true
set :use_sudo, false
set :stage, :production
set :deploy_via, :remote_cache
set :deploy_to, '/home/textbookdialogues/subtitledtrailer'
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"
set :ssh_options, forward_agent: true, user: fetch(:user)
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

set :branch, :master
set :format, :pretty
set :log_level, :debug
set :keep_releases, 5

set :linked_files, %w[.ruby-gemset .ruby-version config/database.yml]
set :linked_dirs,  %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads node_modules]

set :tmp_dir, "/home/textbookdialogues/subtitledtrailer"

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
end
