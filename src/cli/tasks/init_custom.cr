class LuckyCli::InitCustom < LuckyCli::Init
  def run
    project_name = ProjectName.new(ARGV[1]? || "")

    if project_name.valid?
      generate_project(project_name)
    else
      puts project_name.validation_error_message.colorize.red.bold
      exit(1)
    end
  end

  private def generate_project(project_name)
    api_only = false
    authentication = true
    project_directory = "."
    OptionParser.parse do |parser|
      parser.banner = <<-TEXT
      Usage: lucky init.custom NAME [arguments]

      Examples:

        lucky init.custom my_project
        lucky init.custom my_api --api --no-auth --dir ~/Projects/

      TEXT
      parser.on("--api", "Generates an api-only web app") { api_only = true }
      parser.on("--no-auth", "Skips generating authentication") { authentication = false }
      parser.on("--dir DIRECTORY", "Specify the directory to generate your app in. Default is current directory") { |dir|
        project_directory = dir
      }
      parser.on("-h", "--help", "This help message") {
        puts parser
        exit(0)
      }
    end

    LuckyCli::Generators::Web.run(
      project_name: project_name.to_s,
      api_only: api_only,
      generate_auth: authentication,
      project_directory: project_directory
    )
  end
end
