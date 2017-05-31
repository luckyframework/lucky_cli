class LuckyCli::Generators::Web
  include LuckyCli::GeneratorHelpers

  getter :project_name

  def initialize(@project_name : String)
    @template_dir = File.join(__DIR__, "templates")
    @project_dir = @project_name
  end

  def self.run
    project_name = ask_for_project_name

    new(project_name).run
  end

  def self.ask_for_project_name
    puts "#{arrow} What is the name of your project?"
    project_name = gets.to_s

    if project_name.strip == ""
      puts "Enter a project name".colorize(:yellow)
      ask_for_project_name
    else
      project_name
    end
  end

  def run
    generate_default_crystal_project
    add_deps_to_shard_file
    remove_generated_src_files
    add_deps_file
    add_app_file
    add_server_file
    add_default_project_structure
    add_tasks_file
    add_hello_world_action
    add_webpacker
    # add_base_classes
    # add_config_file
    # install_shards
    puts "All done!".colorize(:green)
  end

  private def add_webpacker
    LuckyCli::Generators::Webpack.run(project_name)
  end

  private def remove_generated_src_files
    FileUtils.rm_r(["#{project_name}/src/#{project_name}", "#{project_name}/src/#{project_name}.cr"])
  end

  private def add_deps_file
    deps_file = <<-DEPS_FILE
    require "lucky_record"
    require "lucky_web"
    require "lucky_migrator"
    DEPS_FILE

    File.write("#{project_name}/src/dependencies.cr", deps_file)
  end

  private def add_app_file
    puts "Adding default file structure"
    app_file = <<-APP_FILE
    require "./dependencies"
    require "./models/**"
    require "./queries/**"
    require "./forms/**"
    require "./actions/**"
    require "./pages/**"
    APP_FILE

    File.write("#{project_name}/src/app.cr", app_file)
  end

  private def add_default_project_structure
    add_default_dirs %w(src/models src/queries src/forms src/actions src/pages tasks)
  end

  private def add_default_dirs(dir_names)
    dir_names.each do |dir_name|
      FileUtils.mkdir_p("#{project_name}/#{dir_name}")
      File.write("#{project_name}/#{dir_name}/.keep", "")
    end
  end

  private def add_tasks_file
    puts "Adding tasks"
    tasks_file = <<-TASKS_FILE
    # Load Lucky and the app (actions, models, etc.)
    require "./src/app/*"
    # You can add your own tasks here in the ./tasks folder
    require "./tasks/*"

    LuckyCli::Runner.run
    TASKS_FILE

    File.write("#{project_name}/tasks.cr", tasks_file)
  end

  private def add_hello_world_action
    hello_world = <<-HELLO_WORLD
    class AppHome < LuckyWeb::Action
      get "/" do
        render_text "Welcome to Lucky!"
      end
    end
    HELLO_WORLD

    File.write("#{project_name}/src/actions/app_home.cr", hello_world)
  end

  private def add_server_file
    server_file = <<-SERVER_FILE
    require "./app"
    require "colorize"

    server = HTTP::Server.new("127.0.0.1", 8080, [
      HTTP::ErrorHandler.new,
      HTTP::LogHandler.new,
      LuckyWeb::RouteHandler.new,
    ])

    puts "Listening on http://127.0.0.1:8080...".colorize(:green)

    server.listen
    SERVER_FILE

    File.write("#{project_name}/src/server.cr", server_file)
  end

  private def generate_default_crystal_project
    puts "Generating crystal project for #{project_name.colorize(:cyan)}"
    Process.run "crystal init app #{project_name}",
      shell: true,
      output: true,
      error: true
  end

  private def add_deps_to_shard_file
    puts "Adding deps to shards.yml"
    append_text to: "shard.yml", text: <<-DEPS_LIST

    dependencies:
      lucky_web:
        github: luckyframework/web
      lucky_record:
        github: luckyframework/record
      lucky_migrator:
        github: luckyframework/migrator
    DEPS_LIST
  end
end
