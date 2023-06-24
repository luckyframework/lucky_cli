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

  private def browser? : Bool
    !api_only?
  end

  def run : Nil
    ensure_directory_does_not_exist
    generate_default_project
    generate_shard_yml

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
      File.join(full_project_directory, project_dir)
    end
  end

  private def setup_gitignore
    File.open(File.join(project_dir, ".gitignore"), "w") do |io|
      io << <<-TEXT
      /docs/
      /lib/
      /bin/
      /.shards/
      *.dwarf
      start_server
      *.dwarf
      *.local.cr
      .env
      /tmp
      TEXT

      if browser?
        io << <<-TEXT
        /public/js
        /public/css
        /public/mix-manifest.json
        /node_modules
        yarn-error.log
        TEXT
      end
    end
  end

  private def add_default_lucky_structure_to_src
    SrcTemplate.new(project_name, generate_auth: generate_auth?, api_only: api_only?, with_sec_tester: with_sec_tester?)
      .render(project_dir, force: true)
  end

  private def add_browser_app_structure_to_src
    BrowserSrcTemplate.new(generate_auth: generate_auth?)
      .render(project_dir, force: true)
  end

  private def add_base_auth_to_src
    BaseAuthenticationSrcTemplate.new.render(Path[project_dir])
  end

  private def add_api_authentication_to_src
    ApiAuthenticationTemplate.new.render(Path[project_dir])
  end

  private def add_browser_authentication_to_src
    BrowserAuthenticationSrcTemplate.new.render(project_dir, force: true)
  end

  private def add_sec_tester_to_src
    AppWithSecTesterTemplate.new(generate_auth: generate_auth?, browser: browser?)
      .render(Path[project_dir])
  end

  private def install_shards
    puts "Installing shards"
    run_command "shards install"
  end

  private def generate_default_project : Nil
    Dir.mkdir_p(project_dir)
  end

  private def generate_shard_yml : Nil
    ShardFileGenerator.new(
      project_name,
      generate_auth: generate_auth?,
      browser: browser?,
      with_sec_tester: with_sec_tester?
    )
      .render(Path[project_dir])
  end

  private def ensure_directory_does_not_exist
    if Dir.exists?(project_dir)
      puts "Folder named #{project_dir} already exists, please use a different name".colorize.red.bold
      exit
    end
  end
end
