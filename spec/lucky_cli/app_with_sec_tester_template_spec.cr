require "../spec_helper"

describe AppWithSecTesterTemplate do
  around_each do |example|
    with_tempfile("tmp") do |tmp|
      Dir.mkdir_p(tmp)
      Dir.cd(tmp) do
        example.run
      end
    end
  end

  it "generates app with sec tester template" do
    generate_snapshot("app_sec_tester_template") do
      AppWithSecTesterTemplate.new(
        generate_auth: false,
        browser: false
      )
    end
  end

  it "generates app with sec tester template with only generate auth option" do
    generate_snapshot("app_sec_tester_template__generate_auth") do
      AppWithSecTesterTemplate.new(
        generate_auth: true,
        browser: false
      )
    end
  end

  it "generates app with sec tester template with only browser option" do
    generate_snapshot("app_sec_tester_template__browser") do
      AppWithSecTesterTemplate.new(
        generate_auth: false,
        browser: true
      )
    end
  end
end
