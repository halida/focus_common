namespace :systemd do

  [:start, :stop, :restart].each do |cmd|
    task "app_#{cmd}" do
      on roles(:app), in: :sequence, wait: 5 do
        within release_path do
          execute "sudo systemctl #{cmd} rails_#{fetch(:application)}"
        end
      end
    end

    task "sidekiq_#{cmd}" do
      on roles(:app), in: :sequence, wait: 5 do
        within release_path do
          execute "sudo systemctl #{cmd} sidekiq_#{fetch(:application)}"
        end
      end
    end
  end

end

namespace :thin do
  [:start, :stop, :restart].each do |cmd|
    task "#{cmd}" do
      on roles(:app), in: :sequence, wait: 5 do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :bundle, "exec", "thin", cmd, "-C", "config/thin.yml"
          end
        end
      end
    end
  end
end


namespace :helpers do
  task :test do
    on roles(:app) do
      within release_path do
        execute :echo, '$STAGE'
      end
    end
  end
end
