set :user, "mbg"
set :application, "rbdb"
set :repository,  "git@github.com:railsrumble/mbg.git"

set :deploy_via, :copy
set :copy_strategy, :export
set :copy_exclude, ['.git']
set :branch, "master"
set :git_enable_submodules, 1
set :git_shallow_clone, 1
set :ssh_options, { :forward_agent => true }


role :app, "li47-145.members.linode.com"
role :db, "li47-145.members.linode.com", :primary => true
role :web, "li47-145.members.linode.com"

set :deploy_to, "/var/www/apps/#{application}"
set :scm, :git

namespace :deploy do
  desc "restart passenger"
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is no-op with passenger"
    task t, :roles => :app do ; end
  end

  task :after_symlink do
    %w[database.yml].each do |c|
      run "ln -nsf #{shared_path}/system/config/#{c} #{current_path}/config/#{c}"
    end
  end
end