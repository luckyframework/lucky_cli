require "../spec_helper"

include ShouldRunSuccessfully

describe "Initializing a new web project" do
  it "creates a full web app successfully" do
    puts "Web app: Running integration spec. This might take awhile...".colorize(:yellow)
    with_project_cleanup do
      should_run_successfully "crystal run src/lucky.cr -- init.custom test-project"
      FileUtils.cp("spec/support/cat.gif", "test-project/public/assets/images/")

      # Testing that dashes are translated to underscores
      shard_yml_name = File.read_lines("test-project/shard.yml").find { |line| line =~ /^name:/ }
      shard_yml_name.should eq("name: test_project")
      File.exists?("test-project/src/test_project.cr").should be_true

      File.delete("test-project/.env")
      compile_and_run_specs_on_test_project
      File.read("test-project/Procfile").should contain "test_project"
      File.read("test-project/.travis.yml").should contain "postgresql"
      File.read(".github/workflows/ci.yml").should contain "postgres"
      File.read("test-project/public/mix-manifest.json").should contain "images/cat.gif"
      File.exists?("test-project/public/favicon.ico").should eq true
      File.exists?("test-project/.env").should eq true
    end
  end

  it "creates a full web app with generator" do
    puts "Web app generators: Running integration spec. This might take awhile...".colorize(:yellow)
    with_project_cleanup do
      should_run_successfully "crystal run src/lucky.cr -- init.custom test-project"

      FileUtils.cd "test-project" do
        should_run_successfully "shards install --ignore-crystal-version"
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
        should_run_successfully "crystal build src/start_server.cr"
      end
    end
  end

  it "creates an api only web app successfully" do
    puts "Api only: Running integration spec. This might take awhile...".colorize(:yellow)
    with_project_cleanup do
      should_run_successfully "crystal run src/lucky.cr -- init.custom test-project --api"
      compile_and_run_specs_on_test_project
    end
  end

  it "creates an api only app without auth" do
    puts "Api only without auth: Running integration spec. This might take awhile...".colorize(:yellow)
    with_project_cleanup do
      should_run_successfully "crystal run src/lucky.cr -- init.custom test-project --api --no-auth"
      compile_and_run_specs_on_test_project
    end
  end

  it "creates a full app without auth" do
    puts "Web app without auth: Running integration spec. This might take awhile...".colorize(:yellow)
    with_project_cleanup do
      should_run_successfully "crystal run src/lucky.cr -- init.custom test-project --no-auth"
      compile_and_run_specs_on_test_project
    end
  end

  it "creates a full app in a different directory" do
    puts "Web app with custom directory: Running integration spec.".colorize(:yellow)
    with_project_cleanup(project_directory: "/tmp/home/bob/test-project", skip_db_drop: true) do
      FileUtils.mkdir_p "/tmp/home/bob"
      should_run_successfully "crystal run src/lucky.cr -- init.custom test-project --dir /tmp/home/bob"
      FileUtils.cd "/tmp/home/bob/test-project" do
        File.read("src/shards.cr").should contain "lucky"
      end
    end
  end

  it "does not create project if directory with same name already exist" do
    FileUtils.mkdir "test-project"
    output = IO::Memory.new
    Process.run(
      "crystal run src/lucky.cr -- init.custom test-project",
      output: output,
      shell: true
    )
    message = "Folder named test-project already exists, please use a different name"
    output.to_s.strip.should contain(message)
    FileUtils.rm_rf "test-project"
  end

  it "does not create project if project name is not a valid project name" do
    output = IO::Memory.new
    Process.run(
      "crystal run src/lucky.cr -- init.custom 'test project'",
      env: ENV.to_h,
      output: output,
      shell: true
    )
    message = "Project name should only contain lowercase letters, numbers, underscores, and dashes."
    output.to_s.strip.should contain(message)
  end

  it "does not create project if the project name is reserved" do
    output = IO::Memory.new
    Process.run(
      "crystal run src/lucky.cr -- init.custom 'app'",
      env: ENV.to_h,
      output: output,
      shell: true
    )
    message = "Projects cannot be named app, app_database, app_server, shards, start_server."
    output.to_s.strip.should contain(message)
  end
end

private def compile_and_run_specs_on_test_project
  FileUtils.cd "test-project" do
    should_run_successfully "crystal tool format --check spec src config"
    should_run_successfully "script/setup"
    should_run_successfully "crystal build src/start_server.cr"
    should_run_successfully "crystal build src/test_project.cr"
    should_run_successfully "crystal src/app.cr"
    should_run_successfully "crystal build src/start_server.cr"
    should_run_successfully "crystal spec"
  end
end

private def with_project_cleanup(project_directory = "test-project", skip_db_drop = false)
  yield

  FileUtils.cd(project_directory) {
    output = IO::Memory.new
    Process.run(
      "lucky db.drop",
      output: output,
      shell: true
    )

    output.to_s.should contain("Done dropping")
  } unless skip_db_drop
ensure
  FileUtils.rm_rf project_directory
end
