class LuckyCli::Generators::Web
  include LuckyCli::GeneratorHelpers

  getter project_name

  def initialize(@project_name : String)
    @project_name = @project_name.gsub(" ", "")
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
    ensure_directory_does_not_exist
    generate_default_crystal_project
    add_deps_to_shard_file
    remove_generated_src_files
    remove_generated_spec_files
    remove_default_readme
    add_default_lucky_structure_to_src
    setup_gitignore
    puts <<-TEXT
    Done generating your Lucky project

      #{green_arrow} cd into #{project_name.colorize(:green)}
      #{green_arrow} run #{"bin/setup".colorize(:green)}
      #{green_arrow} run #{"lucky dev".colorize(:green)} to start the server
    TEXT
  end

  private def setup_gitignore
    remove_bin_from_gitignore
    append_text to: ".gitignore", text: <<-TEXT
    /node_modules
    yarn-error.log
    /public/
    server
    TEXT
  end

  private def remove_bin_from_gitignore
    within_project do
      file = File.read(".gitignore")
      updated_file = file.gsub("/bin/\n", "")
      File.write(".gitignore", updated_file)
    end
  end

  private def add_default_lucky_structure_to_src
    SrcTemplate.new(project_name).render("./#{project_name}")
  end

  private def remove_generated_src_files
    FileUtils.rm_r("#{project_dir}/src")
  end

  private def remove_generated_spec_files
    FileUtils.rm_r("#{project_dir}/spec")
  end

  private def remove_default_readme
    FileUtils.rm_r("#{project_dir}/README.md")
  end

  private def install_shards
    puts "Installing shards"
    run_command "shards install"
  end

  private def generate_default_crystal_project
    puts "Generating crystal project for #{project_name.colorize(:cyan)}"
    io = IO::Memory.new
    Process.run "crystal init app #{project_name}",
      shell: true,
      output: io,
      error: STDERR
  end

  private def add_deps_to_shard_file
    puts "Adding Lucky dependencies to shards.yml"
    append_text to: "shard.yml", text: <<-DEPS_LIST

    dependencies:
      lucky:
        github: luckyframework/lucky
        version: "~> 0.7.0"
      lucky_migrator:
        github: luckyframework/lucky_migrator
        version: "~> 0.3.0"
    DEPS_LIST
  end

  private def ensure_directory_does_not_exist
    if Dir.exists?("./#{project_dir}")
      puts "Folder named #{project_name} already exists, please use a different name"
      exit
    end
  end
end
