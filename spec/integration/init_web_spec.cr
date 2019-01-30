require "../spec_helper"

include ShouldRunSuccessfully

Spec.before_each do
  FileUtils.mkdir_p(temp_folder)
  FileUtils.rm_rf("/tmp/lucky_cli/test-project")
end

describe "Initializing a new web project" do
  it "creates a full web app successfully" do
    in_temp_folder do
      puts "Web app: Running integration spec. This might take awhile...".colorize(:yellow)
      should_run_successfully "lucky init test-project"
      FileUtils.cp("#{src_folder_in_docker}/spec/support/cat.gif", "#{temp_folder}/test-project/public/assets/images/")
      compile_and_run_specs_on_test_project
      File.read("test-project/.travis.yml").should contain "postgresql"
      File.read("test-project/public/mix-manifest.json").should contain "images/cat.gif"
      File.exists?("test-project/public/favicon.ico").should eq true
      File.exists?("test-project/.env").should eq true
    end
  end

  it "creates a full web app with generator" do
    in_temp_folder do
      puts "Web app generators: Running integration spec. This might take awhile...".colorize(:yellow)
      should_run_successfully "lucky init test-project"

      FileUtils.cd "test-project" do
        should_run_successfully "shards install"
        should_run_successfully "lucky gen.action.api Api::Users::Show"
        should_run_successfully "lucky gen.action.browser Users::Show"
        should_run_successfully "lucky gen.migration CreateThings"
        should_run_successfully "lucky gen.model User"
        should_run_successfully "lucky gen.page Users::IndexPage"
        should_run_successfully "lucky gen.component Users::Header"
        should_run_successfully "lucky gen.resource.browser Comment title:String"

        File.read("src/actions/comments/index.cr").should contain "Comments::Index"
        File.read("src/actions/api/users/show.cr").should_not be_nil
        File.read("src/actions/users/show.cr").should_not be_nil
        File.read("src/pages/users/index_page.cr").should_not be_nil
        File.read("src/components/users/header.cr").should contain "Users::Header < BaseComponent"
        should_run_successfully "crystal build src/server.cr"
      end
    end
  end

  it "creates an api only web app successfully" do
    in_temp_folder do
      puts "Api only: Running integration spec. This might take awhile...".colorize(:yellow)
      should_run_successfully "lucky init test-project -- --api"
      compile_and_run_specs_on_test_project
    end
  end

  it "creates an api only app without auth" do
    in_temp_folder do
      puts "Api only without auth: Running integration spec. This might take awhile...".colorize(:yellow)
      should_run_successfully "lucky init test-project -- --api --no-auth"
      compile_and_run_specs_on_test_project
    end
  end

  it "creates a full app without auth" do
    in_temp_folder do
      puts "Web app without auth: Running integration spec. This might take awhile...".colorize(:yellow)
      should_run_successfully "lucky init test-project -- --no-auth"
      compile_and_run_specs_on_test_project
    end
  end

  it "does not create project if directory with same name already exist" do
    in_temp_folder do
      FileUtils.mkdir "test-project"
      output = IO::Memory.new
      Process.run(
        "lucky init test-project",
        output: output,
        shell: true
      )
      message = "Folder named test-project already exists, please use a different name"
      output.to_s.strip.should contain(message)
    end
  end

  it "does not create project if project name is not a valid project name" do
    in_temp_folder do
      output = IO::Memory.new
      Process.run(
        "lucky init 'test project'",
        env: ENV.to_h,
        output: output,
        shell: true
      )
      message = "Project name should only contain letters, numbers, underscores, and dashes."
      output.to_s.strip.should contain(message)
    end
  end

  it "translates dashes to underscores in the project name" do
    in_temp_folder do
      output = IO::Memory.new
      Process.run(
        "lucky init 'test-project'",
        env: ENV.to_h,
        output: output,
        shell: true
      )

      shard_yml_name = File.read_lines("test-project/shard.yml").select { |line| line =~ /^name:/ }.first
      shard_yml_name.should eq("name: test_project")
      File.exists?("test-project/src/test_project.cr").should be_true
    end
  end
end

private def in_temp_folder
  FileUtils.cd temp_folder do
    yield
  end
end

private def temp_folder
  "/tmp/lucky_cli"
end

# This is where the source code is mounted in Docker
private def src_folder_in_docker
  "/data"
end

private def compile_and_run_specs_on_test_project
  FileUtils.cd "test-project" do
    should_run_successfully "bin/setup"
    should_run_successfully "crystal tool format --check spec src"
    should_run_successfully "crystal build src/server.cr"
    should_run_successfully "crystal build src/test_project.cr"
    should_run_successfully "crystal src/app.cr"
    should_run_successfully "crystal spec"
  end
end
