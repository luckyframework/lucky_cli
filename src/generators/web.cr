require "option_parser"

class LuckyCli::Generators::Web
  include LuckyCli::GeneratorHelpers

  getter project_name : String
  delegate api_only?, generate_auth?, to: @options

  def initialize(
    project_name : String,
    @options : Options
  )
    @project_dir = project_name
    @project_name = project_name.gsub('-', '_')

    validate_project_name @project_name

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
    end

    if browser? && generate_auth?
      add_browser_authentication_to_src
    end

    # TODO: Add API auth with JWT
    # if api_only? && generate_auth?
    #   add_api_authentication_to_src
    # end

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
    SrcTemplate.new(project_name, @options).render("./#{project_dir}", force: true)
  end

  private def add_browser_app_structure_to_src
    BrowserSrcTemplate.new(@options).render("./#{project_dir}", force: true)
  end

  private def add_base_auth_to_src
    BaseAuthenticationSrcTemplate.new.render("./#{project_dir}", force: true)
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
        branch: master
      authentic:
        github: luckyframework/authentic
        branch: master
      carbon:
        github: luckyframework/carbon
        version: ~> 0.1.0
      dotenv:
        github: gdotdesign/cr-dotenv
    DEPS_LIST

    if browser?
      append_text to: "shard.yml", text: <<-DEPS_LIST

        lucky_flow:
          github: luckyframework/lucky_flow
          branch: master
      DEPS_LIST
    end
  end

  private def ensure_directory_does_not_exist
    if Dir.exists?("./#{project_dir}")
      puts "Folder named #{project_dir} already exists, please use a different name".colorize.red.bold
      exit
    end
  end

  private def validate_project_name(name)
    unless Validators::ProjectName.valid?(name)
      message = <<-TEXT
      Project name should only contain lowercase letters, numbers, underscores, and dashes.

      How about: lucky init '#{Validators::ProjectName.sanitize(name)}'?
      TEXT

      puts message.colorize(:red)
      exit
    end
  end

  class Options
    getter? api_only, generate_auth

    def initialize(
      api_only? @api_only : Bool,
      generate_auth? @generate_auth : Bool
    )
    end
  end
end
