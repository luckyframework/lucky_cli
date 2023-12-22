require "colorize"
require "ecr"
require "athena-console"
# require "./lucky_cli"

# Create an ACON::Application, passing it the name of your CLI.
# Optionally accepts a second argument representing the version of the CLI.
application = ACON::Application.new("lucky", "2.0.0-alpha")

class InitCommand < ACON::Command
  def configure : Nil
    name("init")
    description("Start the Lucky wizard")
    help("Run this to start the new application wizard")
  end

  def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
    style = ACON::Style::Athena.new(input, output)

    style.puts "Welcome to Lucky 🎉\n\n"

    project_name = style.ask(project_name_question)

    style.text "Lucky can generate different types of projects"
    style.new_line
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
    api_only = style.ask(api_only_question)

    if api_only == "api"
      style.text "Lucky can be generated with email and password authentication with a token"
      style.new_line
      style.listing([
        "Sign in and sign up endpoints that return a JWT with the user id",
        "Mixins for requiring an auth token for endpoints",
        "Generated files can easily be removed/customized later",
      ])
    else
      style.text "Lucky can be generated with email and password authentication"
      style.new_line
      style.listing([
        "Sign in and sign up",
        "Mixins for requiring sign in",
        "Password reset",
        "Token authentication for API endpoints",
        "Generated files can easily be removed/customized later",
      ])
    end
    generate_auth = style.ask(generate_auth_question)

    # LuckyCli::Generators::Web.run(
    # project_name: project_name,
    # api_only: api_only,
    # generate_auth: generate_auth
    # )

    puts({
      "project_name"  => project_name,
      "api_only"      => api_only,
      "generate_auth" => generate_auth,
    })

    ACON::Command::Status::SUCCESS
  end

  private def project_name_question
    ACON::Question(String).new("Project name?", "").tap do |question|
      question.normalizer do |input|
        input.try(&.gsub("'", ""))
      end
      question.validator do |input|
        sanitized_input = input.downcase.gsub(/[^a-z0-9_-]/, "_").strip('_')
        reserved_project_names = %w[app app_database app_server shards start_server]

        if input.empty?
          raise ArgumentError.new("Project name can't be blank")
        elsif reserved_project_names.includes?(sanitized_input)
          raise ArgumentError.new(<<-TEXT)
          Projects cannot be named #{reserved_project_names.join(", ")}.

          How about: 'my_lucky_app'?
          TEXT
        elsif sanitized_input != input
          raise ArgumentError.new(<<-TEXT)
          Project name should only contain lowercase letters, numbers, underscores, and dashes.

          How about: '#{sanitized_input}'?
          TEXT
        else
          input
        end
      end
    end
  end

  private def api_only_question
    ACON::Question::Choice.new("API only or full support for HTML and Webpack?", {"yes" => "api", "no" => "full"})
  end

  private def generate_auth_question
    ACON::Question::Confirmation.new("Generate authentication?", false)
  end
end

application.add(InitCommand.new)

# Run the application.
# By default this uses STDIN and STDOUT for its input and output.
application.run
