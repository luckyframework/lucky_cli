class LuckyCli::Generators::TasksFile
  def self.run
    new.run
  end

  def run
    File.write("./tasks.cr", default_tasks_file)
    puts "\nSuccess!".colorize(:green).mode(:bold).to_s + " Generated tasks.cr file"
  end

  private def default_tasks_file
    File.read("./templates/tasks_file/tasks.cr")
  end
end
