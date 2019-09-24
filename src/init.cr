class LuckyCli::Init
  alias Options = Generators::Web::Options

  def self.run
    new.run
  end

  def run
    project_name = name
    if wants_to_generate_task_file?
      LuckyCli::Generators::TasksFile.run
    elsif project_name
      LuckyCli::Generators::Web.run(
        project_name: project_name,
        options: options
      )
    else
      LuckyCli::Wizard::Web.run
    end
  end

  private def options : Options
    api_only = false
    authentication = true
    OptionParser.parse do |parser|
      parser.banner = "Usage: lucky init [arguments]"
      parser.on("--api", "Generates an api-only web app") { api_only = true }
      parser.on("--no-auth", "Does not generate authentication") { authentication = false }
      parser.on("-h", "--help", "This help message") {
        puts parser
        exit(0)
      }
    end

    Generators::Web::Options.new(
      api_only?: api_only,
      generate_auth?: authentication
    )
  end

  private def wants_to_generate_task_file?
    name && name == "tasks.cr"
  end

  private def name
    ARGV[1]?
  end
end
