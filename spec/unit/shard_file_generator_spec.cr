require "../spec_helper"

describe ShardFileGenerator do
  around_each do |example|
    with_tempfile("tmp") do |tmp|
      Dir.mkdir_p(tmp)
      Dir.cd(tmp) do
        example.run
      end
    end
  end

  it "generates shard file template" do
    generate_snapshot("shard_file_template") do
      ShardFileGenerator.new(
        "test-shard",
        generate_auth: true,
        browser: true,
        with_sec_tester: true
      ).tap do |instance|
        instance.crystal_version = "1.10.0"
      end
    end
  end

  it "generates shard file template with only browser option" do
    generate_snapshot("shard_file_template__browser") do
      ShardFileGenerator.new(
        "test-shard",
        generate_auth: false,
        browser: true,
        with_sec_tester: false
      ).tap do |instance|
        instance.crystal_version = "1.10.0"
      end
    end
  end

  it "generates shard file template with only generate auth option" do
    generate_snapshot("shard_file_template__generate_auth") do
      ShardFileGenerator.new(
        "test-shard",
        generate_auth: true,
        browser: false,
        with_sec_tester: false
      ).tap do |instance|
        instance.crystal_version = "1.10.0"
      end
    end
  end

  it "generates shard file template with only sec tester option" do
    generate_snapshot("shard_file_template__with_sec_tester") do
      ShardFileGenerator.new(
        "test-shard",
        generate_auth: false,
        browser: false,
        with_sec_tester: true
      ).tap do |instance|
        instance.crystal_version = "1.10.0"
      end
    end
  end
end
