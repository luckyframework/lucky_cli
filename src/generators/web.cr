class LuckyCli::Generators::Web
  include LuckyCli::GeneratorHelpers

  getter :project_name

  def initialize(@project_name : String)
    @template_dir = File.join(__DIR__, "templates")
    @project_dir = @project_name
  end

  def self.run(project_name : String? = nil)
    if project_name
      new(project_name).run
    else
      project_name = ask_for_project_name
      new(project_name).run
    end
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
    add_default_lucky_structure_to_src
    setup_gitignore
    add_tasks_file
    add_tasks_folder
    add_webpack
    # add_config_file
    add_procfiles
    install_shards
    puts "\nAll done! cd into #{project_name} and run: lucky dev".colorize(:green)
  end

  private def add_procfiles
    copy_template from: "root/Procfile.dev", to: ""
  end

  private def setup_gitignore
    append_text to: ".gitignore", text: <<-TEXT
    /node_modules
    yarn-error.log
    /public/
    server
    TEXT
  end

  private def add_default_lucky_structure_to_src
    copy_all_templates from: "project_src/src", to: "src"
  end

  private def add_webpack
    LuckyCli::Generators::Webpack.run(project_name)
  end

  private def remove_generated_src_files
    FileUtils.rm_r("#{project_dir}/src")
  end

  private def install_shards
    puts "Installing shards"
    run_command "shards install"
  end

  private def add_tasks_file
    puts "Adding tasks"
    tasks_file = <<-TASKS_FILE
    # Load Lucky and the app (actions, models, etc.)
    require "./src/app"
    # You can add your own tasks here in the ./tasks folder
    require "./tasks/**"

    # Load Lucky tasks (dev, webpack.watch, etc.)
    require "lucky_web/tasks/**"

    LuckyCli::Runner.run
    TASKS_FILE

    File.write("#{project_name}/tasks.cr", tasks_file)
  end

  private def add_tasks_folder
    copy_all_templates from: "root/tasks", to: "tasks"
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
      habitat:
        github: luckyframework/habitat
    DEPS_LIST
  end
end
