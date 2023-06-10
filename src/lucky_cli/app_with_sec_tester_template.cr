class AppWithSecTesterTemplate
  getter? generate_auth, browser

  def initialize(@generate_auth : Bool, @browser : Bool)
  end

  def render(path : Path)
    LuckyTemplate.write!(path, template_folder)
  end

  def template_folder
    LuckyTemplate.create_folder do |root_dir|
      root_dir.add_folder("spec") do |spec_dir|
        spec_dir.add_file(Path["flows/security_spec.cr"]) do |io|
          ECR.embed("#{__DIR__}/../app_with_sec_tester/security_spec.cr.ecr", io)
        end
        spec_dir.add_file(Path["setup/sec_tester.cr"]) do |io|
          ECR.embed("#{__DIR__}/../app_with_sec_tester/sec_tester.cr.ecr", io)
        end
      end
    end
  end
end
