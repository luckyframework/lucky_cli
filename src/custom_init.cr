class LuckyCli::CustomInit < LuckyCli::Init
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
    OptionParser.parse do |parser|
      parser.banner = "Usage: lucky init [arguments]"
      parser.on("--api", "Generates an api-only web app") { api_only = true }
      parser.on("--no-auth", "Does not generate authentication") { authentication = false }
      parser.on("-h", "--help", "This help message") {
        puts parser
        exit(0)
      }
    end

    LuckyCli::Generators::Web.run(
      project_name: project_name.to_s,
      api_only: api_only,
      generate_auth: authentication
    )
  end
end
