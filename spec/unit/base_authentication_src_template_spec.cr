require "../spec_helper"

describe BaseAuthenticationSrcTemplate do
  around_each do |example|
    with_tempfile("tmp") do |tmp|
      Dir.mkdir_p(tmp)
      Dir.cd(tmp) do
        example.run
      end
    end
  end

  it "generates base authentication src template" do
    generate_snapshot("base_authentication_src_template") do
      BaseAuthenticationSrcTemplate.new
    end
  end
end
