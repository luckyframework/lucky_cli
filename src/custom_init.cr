class LuckyCli::CustomInit < LuckyCli::Init
  alias Options = Generators::Web::Options

  def run
    project_name = ARGV[1]?
    if project_name
      question = Wizard::ProjectNameQuestion.new("", default_answer: project_name.as(String))
      LuckyCli::Generators::Web.run(
        project_name_question: question,
        options: options
      )
    end
  end

  private def options : Proc(Options)
    api_only = false
    authentication = true
    OptionParser.parse! do |parser|
      parser.banner = "Usage: lucky init [arguments]"
      parser.on("--api", "Generates an api-only web app") { api_only = true }
      parser.on("--no-auth", "Does not generate authentication") { authentication = false }
      parser.on("-h", "--help", "This help message") {
        puts parser
        exit(0)
      }
    end

    -> {
      Generators::Web::Options.new(
        api_only?: api_only,
        generate_auth?: authentication
      )
    }
  end
end
