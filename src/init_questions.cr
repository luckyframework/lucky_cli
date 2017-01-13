class LuckyCli::InitQuestions
  def self.run
    new.run
  end

  def run
    case ask_for_project_type
    when "web"
      LuckyCli::Generators::Web.run
    when "tasks.cr"
      LuckyCli::Generators::TasksFile.run
    else
      puts "Must choose either 'web' or 'tasks.cr'".colorize(:yellow)
      ask_again
    end
  end

  private def ask_for_project_type
    puts "#{arrow} Full web project, or just tasks.cr file? (#{option("web")} or #{option("tasks.cr")})"
    gets
  end

  private def option(text)
    text.colorize(:cyan).mode(:bold)
  end

  private def ask_again
    run
  end
end
