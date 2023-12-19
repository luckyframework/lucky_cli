require "../spec_helper"

describe BrowserAuthenticationSrcTemplate do
  around_each do |example|
    with_tempfile("tmp") do |tmp|
      Dir.mkdir_p(tmp)
      Dir.cd(tmp) do
        example.run
      end
    end
  end

  it "generates browser authentication src template" do
    generate_snapshot("browser_authentication_src_template") do
      BrowserAuthenticationSrcTemplate.new
    end
  end
end
