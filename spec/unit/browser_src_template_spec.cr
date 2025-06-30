require "../spec_helper"

describe BrowserSrcTemplate do
  around_each do |example|
    with_tempfile("tmp") do |tmp|
      Dir.mkdir_p(tmp)
      Dir.cd(tmp) do
        example.run
      end
    end
  end

  it "generates browser src template" do
    generate_snapshot("browser_src_template") do
      BrowserSrcTemplate.new(generate_auth: true, asset_builder: "mix")
    end
  end

  it "generates browser src template without generate auth" do
    generate_snapshot("browser_src_template__generate_auth") do
      BrowserSrcTemplate.new(generate_auth: false, asset_builder: "mix")
    end
  end
end
