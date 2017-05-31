require "ecr"

class LuckyCli::Generators::TasksFile
  ECR.def_to_s "#{__DIR__}/templates/tasks_file/tasks.cr.ecr"

  def self.run
    new.run
  end

  def run
    File.write("./tasks.cr", default_tasks_file)
    puts "\nSuccess!".colorize(:green).mode(:bold).to_s + " Generated tasks.cr file"
  end

  private def default_tasks_file
    to_s
  end
end
