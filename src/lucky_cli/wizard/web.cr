class LuckyCli::Wizard::Web
  getter project_name

  def self.run(*args, **named_args)
    new(*args, **named_args).run
  end

  def initialize
  end

  def run
    LuckyCli::Generators::Web.run(
      project_name: ask_for_project_name,
      options: options
    )
  end

  private def ask_for_project_name
    TextQuestion.ask("Project name?").tap do
      puts "\n"
    end
  end

  @_options : Generators::Web::Options?

  private def options : Generators::Web::Options
    @_options ||= begin
      ask_what_options_user_wants.tap do
        puts "\n"
        puts "-----------------------".colorize.dim
        puts "\n"
      end
    end
  end

  private def ask_what_options_user_wants : Generators::Web::Options
    api_only = ask_about_api_only
    Generators::Web::Options.new(
      api_only?: api_only,
      generate_auth?: ask_about_auth(api_only: api_only)
    )
  end

  private def ask_about_api_only : Bool
    puts <<-HELP_TEXT.colorize.dim
    Lucky can generate different types of projects

    Full (recommended for most apps)

     ● Great for server rendered HTML or Single Page Applications
     ● Webpack included
     ● Setup to compile CSS and JavaScript
     ● Support for rendering HTML

    API

     ● Specialized for use with just APIs
     ● No webpack
     ● No static file serving or public folder
     ● No HTML rendering folders

    HELP_TEXT
    LabeledYesNoQuestion.ask(
      "API only or full support for HTML and Webpack?",
      yes_label: "api",
      no_label: "full"
    )
  end

  private def ask_about_auth(api_only : Bool) : Bool
    if api_only
      puts <<-HELP_TEXT.colorize.dim

      Lucky can be generated with email and password authentication with a token

        ● Sign in and sign up endpoints that return a JWT with the user id
        ● Mixins for requiring an auth token for endpoints
        ● Generated files can easily be removed/customized later

      HELP_TEXT
    else
      puts <<-HELP_TEXT.colorize.dim

      Lucky can be generated with email and password authentication

        ● Sign in and sign up
        ● Mixins for requiring sign in
        ● Password reset
        ● Token authentication for API endpoints
        ● Generated files can easily be removed/customized later

      HELP_TEXT
    end
    YesNoQuestion.ask("Generate authentication?")
  end
end
