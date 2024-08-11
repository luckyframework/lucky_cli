class InitCommand < ACON::Command
  def configure : Nil
    name "init"

    description "Start the Lucky wizard"

    help "Run this to start the new application wizard"
  end

  property! project_name : String
  property api_only = false
  property generate_auth = false

  def setup(input : ACON::Input::Interface, output : ACON::Output::Interface) : Nil
    style = ACON::Style::Athena.new(input, output)

    style.title "Welcome to Lucky 🎉"
  end

  def interact(input : ACON::Input::Interface, output : ACON::Output::Interface) : Nil
    style = ACON::Style::Athena.new(input, output)

    @project_name = question_helper(input, output, project_name_question).as(String)

    style.title "Lucky can generate different types of projects"
    style.section "Full (recommended for most apps)"
    style.listing([
      "Greate for server rendered HTML or Single Page Applications",
      "Webpack included",
      "Setup to compile CSS and JavaScript",
      "Support for rendering HTML",
    ])
    style.section "API"
    style.listing([
      "Specialized for use with just APIs",
      "No webpack",
      "No static file serving or public folder",
      "No HTML rendering folders",
    ])

    if question_helper(input, output, api_only_question) == "api"
      @api_only = true
    end

    style.new_line
    if @api_only
      style.title "Lucky can be generated with email and password authentication with a token"
      style.listing([
        "Sign in and sign up endpoints that return a JWT with the user id",
        "Mixins for requiring an auth token for endpoints",
        "Generated files can easily be removed/customized later",
      ])
    else
      style.title "Lucky can be generated with email and password authentication"
      style.listing([
        "Sign in and sign up",
        "Mixins for requiring sign in",
        "Password reset",
        "Token authentication for API endpoints",
        "Generated files can easily be removed/customized later",
      ])
    end

    @generate_auth = question_helper(input, output, generate_auth_question)
    style.new_line
  end

  def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
    LuckyCli::Generators::Web.run(
      project_name: project_name,
      api_only: api_only,
      generate_auth: generate_auth
    )

    ACON::Command::Status::SUCCESS
  end

  private def project_name_question
    ACON::Question(String).new("Project name?", "").tap do |question|
      question.normalizer do |input|
        input.try(&.gsub("'", ""))
      end
      question.validator do |input|
        ProjectNameValidator.call(input)
      end
    end
  end

  private def api_only_question
    ACON::Question::Choice.new(
      "API only or full support for HTML and Webpack?",
      {
        "yes" => "api",
        "no" => "full"
      }
    )
  end

  private def generate_auth_question
    ACON::Question::Confirmation.new("Generate authentication?", false)
  end

  private class CustomAthenaQuestion < ACON::Helper::AthenaQuestion
    def write_error(output : ACON::Output::Interface, error : Exception) : Nil
      output.puts (error.message || "").colorize(:red)
    end
  end

  private def question_helper(input, output, question)
    CustomAthenaQuestion.new.ask(input, output, question)
  end
end
