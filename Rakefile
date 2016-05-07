# Needed to overwrite the already existing Rake task "load_config"
class Rake::Task
  def overwrite(&block)
    @actions.clear
    enhance(&block)
  end
end

# Load the ActiveRecord tasks
spec = Gem::Specification.find_by_name("activerecord")
load File.join(spec.gem_dir, "lib", "active_record", "railties", "databases.rake")

# Overwrite the load config to your needs
Rake::Task["db:load_config"].overwrite do
  ActiveRecord::Base.configurations = ActiveRecord::Tasks::DatabaseTasks.database_configuration = YAML.load_file('db/config.yml')
  ActiveRecord::Tasks::DatabaseTasks.db_dir = 'db'
  ActiveRecord::Tasks::DatabaseTasks.env    = 'development'
end

# Migrations need an environment with an already established database connection
task :environment => ["db:load_config"] do
  ActiveRecord::Base.establish_connection ActiveRecord::Tasks::DatabaseTasks.database_configuration[ActiveRecord::Tasks::DatabaseTasks.env]
end


# Sidekiq
namespace :sidekiq do
  desc "Start the sidekiq worker without daemon"
  task :start do
    sh "bundle exec sidekiq -r ./lib/forocoches_jobs/pole_job.rb -C config/sidekiq.yml"
  end

  desc "Start the sidekiq worker with daemon"
  task :start_daemon do
    Rake::Task["sidekiq:stop_daemon"].invoke
    sh "bundle exec sidekiq -r ./lib/forocoches_jobs/pole_job.rb -C config/sidekiq.yml -d"
  end

  desc "Stop the sidekiq daemon"
  task :stop_daemon do
    begin
      sidekiq_pid = File.read("var/pids/sidekiq.pid").to_i
      kill =  Process.kill('QUIT', sidekiq_pid)
      if kill
        p "Sidekiq daemon stopped"
      else
        p "Error on stopping sidekiq daemon"
      end
    rescue Errno::ESRCH
      p "Not daemon of sidekiq running"
    rescue
      p "error"
    end
  end
end

namespace :app do
  desc "Track the next poles starting from the last one"
  task :track_poles, [:poles_to_track, :jobs_size, :top_limit, :delay]  do |t, args|
    sh "ruby lib/forocoches_jobs/poles.rb #{args[:poles_to_track]} #{args[:jobs_size]} #{args[:top_limit]} #{args[:delay]}"
  end
end