class LuckyCli::Init
  alias Options = Generators::Web::Options

  def self.run
    new.run
  end

  def run
    if wants_to_generate_task_file?
      LuckyCli::Generators::TasksFile.run
    else
      LuckyCli::Wizard::Web.run
    end
  end

  private def wants_to_generate_task_file?
    name && name == "tasks.cr"
  end

  private def name
    ARGV[1]?
  end
end
