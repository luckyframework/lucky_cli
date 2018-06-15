require "option_parser"

class LuckyCli::Generators::Web
  include LuckyCli::GeneratorHelpers

  getter project_name
  getter? api_only : Bool = false

  def initialize(@project_name : String)
    parse_options
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

  private def browser?
    !api_only?
  end

  def run
    ensure_directory_does_not_exist
    generate_default_crystal_project
    add_deps_to_shard_file
    remove_generated_travis_file
    remove_generated_src_files
    remove_generated_spec_files
    remove_default_readme
    add_default_lucky_structure_to_src
    if browser?
      add_browser_app_structure_to_src
    end
    setup_gitignore
    remove_default_license
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
    /public/mix-manifest.json
    /public/js
    /public/css
    /bin/lucky/
    server
    *.dwarf
    *.local.cr
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
    SrcTemplate.new(project_name, @api_only).render("./#{project_name}")
  end

  private def add_browser_app_structure_to_src
    BrowserSrcTemplate.new.render("./#{project_name}")
  end

  private def remove_generated_src_files
    FileUtils.rm_r("#{project_dir}/src")
  end

  private def remove_generated_travis_file
    FileUtils.rm_r("#{project_dir}/.travis.yml")
  end

  private def remove_generated_spec_files
    FileUtils.rm_r("#{project_dir}/spec")
  end

  private def remove_default_readme
    FileUtils.rm_r("#{project_dir}/README.md")
  end

  private def remove_default_license
    remove_license_from_shard
    FileUtils.rm_r("#{project_dir}/LICENSE")
  rescue e : Errno
    puts "License file not deleted because it does not exist"
  end

  private def remove_license_from_shard
    shard_path = "#{project_dir}/shard.yml"
    lines = [] of String
    File.each_line shard_path do |line|
      lines << line unless line.includes?("license")
    end
    File.write shard_path, lines.join("\n")
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
        version: ~> 0.11
      lucky_migrator:
        github: luckyframework/lucky_migrator
        version: ~> 0.6
      authentic:
        github: luckyframework/authentic
        version: ~> 0.1.0
      carbon:
        github: luckyframework/carbon
        version: ~> 0.1.0
    DEPS_LIST

    if browser?
      append_text to: "shard.yml", text: <<-DEPS_LIST

        lucky_flow:
          github: luckyframework/lucky_flow
          version: ~> 0.2
      DEPS_LIST
    end
  end

  private def ensure_directory_does_not_exist
    if Dir.exists?("./#{project_dir}")
      puts "Folder named #{project_name} already exists, please use a different name"
      exit
    end
  end

  private def parse_options
    OptionParser.parse! do |parser|
      parser.banner = "Usage: lucky init [arguments]"
      parser.on("--api", "Generates an api-only web app") { @api_only = true }
      parser.on("-h", "--help", "Help here") {
        puts parser
        exit(0)
      }
    end
  end
end
