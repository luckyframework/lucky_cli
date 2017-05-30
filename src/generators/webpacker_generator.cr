class WebpackerGenerator
  def initialize(@project_name : String)
  end

  def self.run(project_name : String)
    puts "Add webpacker config"
    new(project_name).run
  end

  def run
    FileUtils.cp_r("#{__DIR__}/webpacker_templates", "#{@project_name}/config/")
  end
end
