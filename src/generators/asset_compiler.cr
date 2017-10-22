class LuckyCli::Generators::AssetCompiler
  include LuckyCli::GeneratorHelpers

  def initialize(project_name)
    @project_dir = File.join(project_name)
    @template_dir = "unused"
  end

  def self.run(project_name : String)
    new(project_name).install
  end

  def install
    puts "Installing all JavaScript dependencies"
    run_command "yarn install"
  end
end
