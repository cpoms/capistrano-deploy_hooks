namespace :deploy_hooks do
  namespace :deploy do
    task :updating do
      Capistrano::DeployHooks::Main.new(self).run(:updating)
    end

    task :reverting do
      Capistrano::DeployHooks::Main.new(self).run(:reverting)
    end

    task :updated do
      Capistrano::DeployHooks::Main.new(self).run(:updated)
    end

    task :reverted do
      Capistrano::DeployHooks::Main.new(self).run(:reverted)
    end

    task :failed do
      Capistrano::DeployHooks::Main.new(self).run(:failed)
    end

    task :test => %i[updating updated reverting reverted failed] do
      # all tasks run as dependencies
    end
  end
end

before 'deploy:updating',           'deploy_hooks:deploy:updating'
before 'deploy:reverting',          'deploy_hooks:deploy:reverting'
after  'deploy:finishing',          'deploy_hooks:deploy:updated'
after  'deploy:finishing_rollback', 'deploy_hooks:deploy:reverted'
after  'deploy:failed',             'deploy_hooks:deploy:failed'
