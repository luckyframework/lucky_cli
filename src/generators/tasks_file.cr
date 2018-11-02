class LuckyCli::Generators::TasksFile
  def self.run
    new.run
  end

  def run
    File.write("./tasks.cr", default_tasks_file)
    puts "\nSuccess!".colorize(:green).mode(:bold).to_s + " Generated tasks.cr file"
  end

  private def default_tasks_file
    <<-TASKS_FILE
    # Remember to add lucky_cli to your shards.yml file, then run `shards`
    require "lucky_cli"

    # Uncomment to require your lib or app's source code
    # require "./src/my_project_name"

    # Uncomment this to include tasks from the tasks directory of your project
    # If you have a lot of tasks, this can be cleaner than putting them in this file
    # require "./tasks/**"

    # Write tasks here (or uncomment the line above). Here's an example task
    # class App::SendDailyNotifications < LuckyCli::Task
    #   # What this task does
    #   summary "Send notifications to users"
    #
    #   def call
    #     # Code that sends notifications to all your users
    #     puts "Sent daily notifications!"
    #   end
    # end

    # Make sure this goes last
    LuckyCli::Runner.run
    TASKS_FILE
  end
end
