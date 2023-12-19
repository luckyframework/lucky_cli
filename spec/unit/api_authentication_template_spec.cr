require "../spec_helper"

describe ApiAuthenticationTemplate do
  around_each do |example|
    with_tempfile("tmp") do |tmp|
      Dir.mkdir_p(tmp)
      Dir.cd(tmp) do
        example.run
      end
    end
  end

  it "generates api authentication template" do
    generate_snapshot("api_authentication_template") do
      ApiAuthenticationTemplate.new
    end
  end
end
