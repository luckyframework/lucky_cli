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
    add_asset_compilation
    install_shards
    puts "\nAll done! cd into #{project_name.colorize(:green)} and run #{"lucky dev".colorize(:green)}"
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
    SrcTemplate.new(project_name).render("./#{project_name}")
  end

  private def add_asset_compilation
    LuckyCli::Generators::AssetCompiler.run(project_name)
  end

  private def remove_generated_src_files
    FileUtils.rm_r("#{project_dir}/src")
  end

  private def install_shards
    puts "Installing shards"
    run_command "shards install"
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
        branch: master
      lucky_migrator:
        github: luckyframework/migrator
        version: ~> 0.2.3
    DEPS_LIST
  end
end
