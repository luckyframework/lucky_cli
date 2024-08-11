class InitCustomCommand < ACON::Command
  def configure : Nil
    name "init:custom"

    aliases "init.custom"

    description "Generate a new Lucky application"

    argument "name", :required
    option "api", description: "Generates an api-only web app"
    option "auth", value_mode: :negatable, description: "Skips generating authentication", default: true
    option "with-sec-test", description: "Adds in SecTest integration"
    option "dir", value_mode: :required, description: "Specify the directory to generate your app in. Default is the current directory"

    usage "my_project"
    usage "my_api --api --no-auth --with-sec-test --dir ~/Projects/"
  end

  property! project_name : String

  def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
    validate_project_name(input, output)

    unless project_name?
      return ACON::Command::Status::INVALID
    end

    LuckyCli::Generators::Web.run(
      project_name: project_name,
      api_only: input.option("api", Bool),
      generate_auth: input.option("auth", Bool),
      with_sec_tester: input.option("with-sec-test", Bool),
      project_directory: input.option("dir") || "."
    )

    ACON::Command::Status::SUCCESS
  end

  private def validate_project_name(input, output) : Nil
    style = ACON::Style::Athena.new(input, output)

    name = input.argument("name", String)
    begin
      ProjectNameValidator.call(name)
      @project_name = name
    rescue err
      style.puts (err.message || "").colorize(:red)
    end
  end
end
