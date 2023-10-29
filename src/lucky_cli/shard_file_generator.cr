require "yaml"
require "lucky_template"

class ShardFileGenerator
  getter project_name : String
  getter? generate_auth : Bool
  getter? browser : Bool
  getter? with_sec_tester : Bool

  def initialize(
    @project_name : String,
    @generate_auth : Bool,
    @browser : Bool,
    @with_sec_tester : Bool
  )
  end

  def render(path : Path)
    LuckyTemplate.write!(path, template_folder)
  end

  def template_folder
    LuckyTemplate.create_folder do |top_dir|
      top_dir.add_file("shard.yml", shard_yml.to_yaml)
    end
  end

  def shard_yml
    {
      "name"    => project_name,
      "version" => "0.1.0",
      "targets" => {
        project_name => {
          "main" => Path.new("src", "#{project_name}.cr").to_s,
        },
      },
      "crystal"                  => ">= #{Crystal::VERSION}",
      "dependencies"             => shard_deps,
      "development_dependencies" => shard_dev_deps,
    }
  end

  private def shard_deps
    deps = project_base_deps
    if generate_auth?
      deps = deps.merge(project_auth_deps)
    end
    deps
  end

  private def shard_dev_deps
    deps = {} of String => String
    if browser?
      deps = deps.merge(project_browser_dev_deps)
    end
    if with_sec_tester?
      deps = deps.merge(project_additional_dev_deps)
    end
    deps
  end

  private def project_base_deps
    {
      "lucky" => {
        "github"  => "luckyframework/lucky",
        "version" => "~> 1.1.0",
      },
      "avram" => {
        "github"  => "luckyframework/avram",
        "version" => "~> 1.1.0",
      },
      "carbon" => {
        "github"  => "luckyframework/carbon",
        "version" => "~> 0.4.0",
      },
      "carbon_sendgrid_adapter" => {
        "github"  => "luckyframework/carbon_sendgrid_adapter",
        "version" => "~> 0.4.0",
      },
      "lucky_env" => {
        "github"  => "luckyframework/lucky_env",
        "version" => "~> 0.2.0",
      },
      "lucky_task" => {
        "github"  => "luckyframework/lucky_task",
        "version" => "~> 0.3.0",
      },
    }
  end

  private def project_auth_deps
    {
      "authentic" => {
        "github"  => "luckyframework/authentic",
        "version" => ">= 1.0.0, < 2.0.0",
      },
      "jwt" => {
        "github"  => "crystal-community/jwt",
        "version" => "~> 1.6.0",
      },
    }
  end

  private def project_browser_dev_deps
    {
      "lucky_flow" => {
        "github"  => "luckyframework/lucky_flow",
        "version" => "~> 0.9.2",
      },
    }
  end

  private def project_additional_dev_deps
    {
      "lucky_sec_tester" => {
        "github"  => "luckyframework/lucky_sec_tester",
        "version" => "~> 0.3.2",
      },
    }
  end
end
