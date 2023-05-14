require "yaml"

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

  private def project_base_dependencies
    {
      lucky:                   {github: "luckyframework/lucky", version: "~> 1.0.0"},
      avram:                   {github: "luckyframework/avram", version: "~> 1.0.0"},
      carbon:                  {github: "luckyframework/carbon", version: "~> 0.3.0"},
      carbon_sendgrid_adapter: {github: "luckyframework/carbon_sendgrid_adapter", version: "~> 0.3.0"},
      lucky_env:               {github: "luckyframework/lucky_env", version: "~> 0.1.4"},
      lucky_task:              {github: "luckyframework/lucky_task", version: "~> 0.1.1"},
    }
  end

  private def project_auth_dependencies
    {
      authentic: {github: "luckyframework/authentic", version: "~> 1.0.0"},
      jwt:       {github: "crystal-community/jwt", version: "~> 1.6.0"},
    }
  end

  private def project_browser_dev_dependencies
    {
      lucky_flow: {github: "luckyframework/lucky_flow", version: "~> 0.9.0"},
    }
  end

  private def project_additional_dev_dependencies
    {
      lucky_sec_tester: {github: "luckyframework/lucky_sec_tester", version: "~> 0.2.0"},
    }
  end

  private def add_dependency(yaml, dep_name, details)
    yaml.scalar dep_name.to_s
    yaml.mapping do
      details.each do |key, value|
        yaml.scalar key.to_s
        yaml.scalar value.to_s
      end
    end
  end

  def render(project_directory : String)
    File.open(File.join(project_directory, "shard.yml"), "w") do |f|
      YAML.build(f) do |yaml|
        yaml.mapping do
          yaml.scalar "name"
          yaml.scalar project_name
          yaml.scalar "version"
          yaml.scalar "0.1.0"
          yaml.scalar "crystal"
          yaml.scalar ">= #{Crystal::VERSION}"
          yaml.scalar "targets"
          yaml.mapping do
            yaml.scalar project_name
            yaml.mapping do
              yaml.scalar "main"
              yaml.scalar File.join("src", "#{project_name}.cr")
            end
          end
          yaml.scalar "dependencies"
          yaml.mapping do
            project_base_dependencies.each do |dep_name, details|
              add_dependency(yaml, dep_name, details)
            end

            if generate_auth?
              project_auth_dependencies.each do |dep_name, details|
                add_dependency(yaml, dep_name, details)
              end
            end
          end
          yaml.scalar "development_dependencies"
          yaml.mapping do
            if browser?
              project_browser_dev_dependencies.each do |dep_name, details|
                add_dependency(yaml, dep_name, details)
              end
            end
            if with_sec_tester?
              project_additional_dev_dependencies.each do |dep_name, details|
                add_dependency(yaml, dep_name, details)
              end
            end
          end
        end
      end
    end
  end
end
