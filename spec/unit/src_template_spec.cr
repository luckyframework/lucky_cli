require "../spec_helper"

describe SrcTemplate do
  around_each do |example|
    with_tempfile("tmp") do |tmp|
      Dir.mkdir_p(tmp)
      Dir.cd(tmp) do
        example.run
      end
    end
  end

  it "generates src template" do
    generate_snapshot("src_template") do
      SrcTemplate.new(
        "test-project",
        generate_auth: true,
        api_only: true,
        with_sec_tester: true,
        js_bundle_system: "yarn",
      ).tap do |instance|
        instance.secret_key_base = "1234567890"
        instance.crystal_version = "1.16.1"
        instance.lucky_cli_version = "1.3.0"
      end
    end
  end

  it "generates src template with only generate auth option" do
    generate_snapshot("src_template__generate_auth") do
      SrcTemplate.new(
        "test-project",
        generate_auth: true,
        api_only: false,
        with_sec_tester: false,
        js_bundle_system: "yarn",
      ).tap do |instance|
        instance.secret_key_base = "1234567890"
        instance.crystal_version = "1.16.1"
        instance.lucky_cli_version = "1.3.0"
      end
    end
  end

  it "generates src template with only api option" do
    generate_snapshot("src_template__api_only") do
      SrcTemplate.new(
        "test-project",
        generate_auth: false,
        api_only: true,
        with_sec_tester: false,
        js_bundle_system: "yarn",
      ).tap do |instance|
        instance.secret_key_base = "1234567890"
        instance.crystal_version = "1.16.1"
        instance.lucky_cli_version = "1.3.0"
      end
    end
  end

  it "generates src template with only sec tester option" do
    generate_snapshot("src_template__sec_tester") do
      SrcTemplate.new(
        "test-project",
        generate_auth: false,
        api_only: false,
        with_sec_tester: true,
        js_bundle_system: "yarn",
      ).tap do |instance|
        instance.secret_key_base = "1234567890"
        instance.crystal_version = "1.16.1"
        instance.lucky_cli_version = "1.3.0"
      end
    end
  end

  it "generates src template with js bundler bun option" do
    generate_snapshot("src_template__js_bun_bundler") do
      SrcTemplate.new(
        "test-project",
        generate_auth: false,
        api_only: false,
        with_sec_tester: true,
        js_bundle_system: "bun",
      ).tap do |instance|
        instance.secret_key_base = "1234567890"
        instance.crystal_version = "1.16.1"
        instance.lucky_cli_version = "1.3.0"
      end
    end
  end
end
