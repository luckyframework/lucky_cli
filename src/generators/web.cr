require "option_parser"

class LuckyCli::Generators::Web
  include LuckyCli::GeneratorHelpers

  getter project_name : String
  getter? api_only, generate_auth, with_sec_tester
  private getter? default_directory : Bool
  private getter full_project_directory : String

  def initialize(
    project_name : String,
    @api_only : Bool,
    @generate_auth : Bool,
    @with_sec_tester : Bool = false,
    project_directory : String = "."
  )
    @full_project_directory = File.expand_path(project_directory)

    if Dir.exists?(@full_project_directory)
      Dir.cd(@full_project_directory)
    else
      puts <<-ERROR.colorize.red
      The directory #{@full_project_directory} does not exist.
      Make sure to create the directory first before generating a new application.
      ERROR

      exit(1)
    end
    @default_directory = project_directory == "."

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
    rename_shard_target_to_app
    add_deps_to_shard_file
    add_dev_deps_to_shard_file
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

    if with_sec_tester?
      add_sec_tester_to_src
    end

    setup_gitignore
    remove_default_license

    puts <<-TEXT
    #{"Done generating your Lucky project".colorize.bold}

      #{green_arrow} cd into #{project_location.colorize(:green)}
      #{green_arrow} check database settings in #{"config/database.cr".colorize(:green)}
      #{green_arrow} run #{"script/setup".colorize(:green)}
      #{green_arrow} run #{"lucky dev".colorize(:green)} to start the server

    TEXT
  end

  private def project_location : String
    if default_directory?
      project_dir
    else
      [full_project_directory.chomp('/'), project_dir].join('/')
    end
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
    SrcTemplate.new(project_name, generate_auth: generate_auth?, api_only: api_only?, with_sec_tester: with_sec_tester?)
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

  private def add_sec_tester_to_src
    AppWithSecTesterTemplate.new(generate_auth: generate_auth?, browser: browser?)
      .render("./#{project_dir}", force: true)
  end

  private def remove_generated_src_files
    remove_default_generated_if_exists("src")
  end

  private def remove_generated_spec_files
    remove_default_generated_if_exists("spec")
  end

  private def remove_default_readme
    remove_default_generated_if_exists("README.md")
  end

  private def remove_default_license
    remove_license_from_shard
    remove_default_generated_if_exists("LICENSE")
  end

  private def remove_default_generated_if_exists(file_or_directory : String)
    to_delete = "#{project_dir}/#{file_or_directory}"
    if File.exists?(to_delete)
      FileUtils.rm_rf(to_delete)
    end
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

  private def rename_shard_target_to_app
    replace_text "shard.yml", from: "#{project_name}:", to: "app:"
  end

  private def add_deps_to_shard_file
    append_text to: "shard.yml", text: <<-DEPS_LIST
    dependencies:
      lucky:
        github: luckyframework/lucky
        branch: main
      avram:
        github: luckyframework/avram
        branch: main
      carbon:
        github: luckyframework/carbon
        version: ~> 0.3.0
      carbon_sendgrid_adapter:
        github: luckyframework/carbon_sendgrid_adapter
        version: ~> 0.3.0
      lucky_env:
        github: luckyframework/lucky_env
        version: ~> 0.1.4
      lucky_task:
        github: luckyframework/lucky_task
        version: ~> 0.1.1
    DEPS_LIST

    if generate_auth?
      append_text to: "shard.yml", text: <<-DEPS_LIST
        authentic:
          github: luckyframework/authentic
          branch: main
        jwt:
          github: crystal-community/jwt
          version: ~> 1.6.0
      DEPS_LIST
    end
  end

  private def needs_development_dependencies?
    browser? || with_sec_tester?
  end

  private def add_dev_deps_to_shard_file
    if needs_development_dependencies?
      append_text to: "shard.yml", text: <<-DEPS_LIST
      development_dependencies:
      DEPS_LIST

      if browser?
        append_text to: "shard.yml", text: <<-DEPS_LIST
          lucky_flow:
            github: luckyframework/lucky_flow
            version: ~> 0.9.0
        DEPS_LIST
      end

      if with_sec_tester?
        append_text to: "shard.yml", text: <<-DEPS_LIST
          lucky_sec_tester:
            github: luckyframework/lucky_sec_tester
            version: ~> 0.1.0
        DEPS_LIST
      end
    end
  end

  private def ensure_directory_does_not_exist
    if Dir.exists?("./#{project_dir}")
      puts "Folder named #{project_dir} already exists, please use a different name".colorize.red.bold
      exit
    end
  end
end
