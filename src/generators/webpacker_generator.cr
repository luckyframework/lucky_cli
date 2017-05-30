class WebpackerGenerator
  def initialize(@project_name : String)
  end

  def self.run(project_name : String)
    puts "Adding webpacker config and asset directories"
    new(project_name).run
  end

  def run
    FileUtils.cp_r("#{__DIR__}/asset_templates", "#{@project_name}/assets/")
    FileUtils.cp_r("#{__DIR__}/webpacker_templates", "#{@project_name}/config/")
  end
end
