require "option_parser"

class LuckyCli::Generators::Web
  include LuckyCli::GeneratorHelpers

  getter project_name : String
  getter? api_only, generate_auth

  def initialize(
    project_name : String,
    @api_only : Bool,
    @generate_auth : Bool,
    project_directory : String = "."
  )
    Dir.cd(File.expand_path(project_directory))

    @project_dir = project_name
    @project_name = @project_dir.gsub('-', '_')

    @template_dir = File.join(__DIR__, "templates")
  end

  def self.run(*args, **named_args)
    new(*args, **named_args).run
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

    if generate_auth?
      add_base_auth_to_src
      add_api_authentication_to_src
    end

    if browser? && generate_auth?
      add_browser_authentication_to_src
    end

    setup_gitignore
    remove_default_license
    puts <<-TEXT
    #{"Done generating your Lucky project".colorize.bold}

      #{green_arrow} cd into #{project_dir.colorize(:green)}
      #{green_arrow} check database settings in #{"config/database.cr".colorize(:green)}
      #{green_arrow} run #{"script/setup".colorize(:green)}
      #{green_arrow} run #{"lucky dev".colorize(:green)} to start the server

    TEXT
  end

  private def setup_gitignore
    append_text to: ".gitignore", text: <<-TEXT
    start_server
    *.dwarf
    *.local.cr
    .env
    /tmp
    TEXT
    if browser?
      append_text to: ".gitignore", text: <<-TEXT
      /public/js
      /public/css
      /public/mix-manifest.json
      /node_modules
      yarn-error.log
      TEXT
    end
  end

  private def add_default_lucky_structure_to_src
    SrcTemplate.new(project_name, generate_auth: generate_auth?, api_only: api_only?)
      .render("./#{project_dir}", force: true)
  end

  private def add_browser_app_structure_to_src
    BrowserSrcTemplate.new(generate_auth: generate_auth?)
      .render("./#{project_dir}", force: true)
  end

  private def add_base_auth_to_src
    BaseAuthenticationSrcTemplate.new.render("./#{project_dir}", force: true)
  end

  private def add_api_authentication_to_src
    ApiAuthenticationTemplate.new.render("./#{project_dir}", force: true)
  end

  private def add_browser_authentication_to_src
    BrowserAuthenticationSrcTemplate.new.render("./#{project_dir}", force: true)
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
    FileUtils.rm_rf("#{project_dir}/LICENSE")
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
    io = IO::Memory.new
    Process.run "crystal init app #{project_name} #{project_dir}",
      shell: true,
      output: io,
      error: STDERR
  end

  private def add_deps_to_shard_file
    append_text to: "shard.yml", text: <<-DEPS_LIST
    dependencies:
      lucky:
        github: luckyframework/lucky
        version: ~> 0.26.0
      authentic:
        github: luckyframework/authentic
        version: ~> 0.7.2
      carbon:
        github: luckyframework/carbon
        version: ~> 0.1.2
      dotenv:
        github: gdotdesign/cr-dotenv
        version: ~> 0.7.0
    DEPS_LIST

    if browser?
      append_text to: "shard.yml", text: <<-DEPS_LIST
        lucky_flow:
          github: luckyframework/lucky_flow
          version: ~> 0.7.2
      DEPS_LIST
    end

    if generate_auth?
      append_text to: "shard.yml", text: <<-DEPS_LIST
        jwt:
          github: crystal-community/jwt
          version: ~> 1.5.0
      DEPS_LIST
    end
  end

  private def ensure_directory_does_not_exist
    if Dir.exists?("./#{project_dir}")
      puts "Folder named #{project_dir} already exists, please use a different name".colorize.red.bold
      exit
    end
  end
end
