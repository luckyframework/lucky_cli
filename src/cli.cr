require "colorize"
require "ecr"
require "athena-console"
# require "./lucky_cli"

# Create an ACON::Application, passing it the name of your CLI.
# Optionally accepts a second argument representing the version of the CLI.
application = ACON::Application.new("lucky", "2.0.0-alpha")

#application.definition = ACON::Input::Definition.new

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

    style.puts "project_name  => #{project_name}"
    style.puts "api_only      => #{api_only}"
    style.puts "generate_auth => #{generate_auth}"

    # TODO
    # LuckyCli::Generators::Web.run(
    # project_name: project_name,
    # api_only: api_only,
    # generate_auth: generate_auth
    # )

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

class DevCommand < ACON::Command
  def configure : Nil
    name "dev"
    description "Boot the lucky development server"
    help <<-TEXT
    Boot your Lucky application. Uses the Procfile.dev to
    run each service. Edit this file to change which services
    are booted.
    TEXT
  end

  def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
    style = ACON::Style::Athena.new(input, output)

    unless inside_app_dir? && has_procfile?
      style.error "You are not in a Lucky project"
      style.text "Try this..."
      style.new_line
      style.listing([
        "Run #{ "lucky init".colorize(:green) } to create a Lucky project.",
        "Change your project's root directory to see what tasks are available.",
      ])
      return ACON::Command::Status::FAILURE
    end

    style.puts "lucky dev started"

    # TODO
    # LuckyCli::Dev.new.call

    ACON::Command::Status::SUCCESS
  end

  private def inside_app_dir? : Bool
    tasks_file = ENV.fetch("LUCKY_TASKS_FILE", "./tasks.cr")
    File.exists?(Path[tasks_file])
  end

  private def has_procfile? : Bool
    File.exists?(Path["Procfile.dev"])
  end
end

class TaskCommand < ACON::Command
  def configure : Nil
    name "task"
    argument("name", :required, "The provided task name")
    argument("args", :is_array, "The arguments to pass along to the task")
    usage("task <name> -- [<args>...]")
  end

  def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
    task_name = input.argument("name")
    task_args = input.argument("args", Array(String))

    style = ACON::Style::Athena.new(input, output)

    style.puts "Name: #{task_name}"
    style.puts "Args: #{task_args.inspect}"

    if File::Info.executable?("./bin/lucky.#{task_name}")
      style.puts "run old process"
    else
      style.puts "run new lua process"
    end

    ACON::Command::Status::SUCCESS
  end
end

application.add InitCommand.new
application.add DevCommand.new
application.add TaskCommand.new

# Run the application.
# By default this uses STDIN and STDOUT for its input and output.
application.run
