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

begin
	require 'rspec/core/rake_task'

	RSpec::Core::RakeTask.new(:spec)

	task :default => :spec

rescue LoadError
end