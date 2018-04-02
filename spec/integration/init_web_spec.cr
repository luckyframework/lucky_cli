require "../spec_helper"

describe "Initializing a new web project" do
  it "creates a full web app successfully" do
    begin
      puts "Web app: Running integration spec. This might take awhile...".colorize(:yellow)
      should_run_successfully "rm -rf ./test-project"
      should_run_successfully "crystal src/lucky.cr init test-project"
      compile_and_run_specs_on_test_project
    ensure
      FileUtils.rm_rf "test-project"
    end
  end

  it "creates an api only web app successfully" do
    begin
      puts "Api Only: Running integration spec. This might take awhile...".colorize(:yellow)
      should_run_successfully "rm -rf ./test-project"
      should_run_successfully "crystal build src/lucky.cr -o api_only"
      should_run_successfully "./api_only init test-project --api"
      compile_and_run_specs_on_test_project
    ensure
      FileUtils.rm_rf "test-project"
      FileUtils.rm "api_only"
    end
  end

  it "does not create project if directory with same name already exist" do
    begin
      FileUtils.mkdir "test-project"
      output = IO::Memory.new
      Process.run(
        "crystal src/lucky.cr init test-project",
        output: output,
        shell: true
      )
      message = "Folder named test-project already exists, please use a different name"
      output.to_s.strip.should eq(message)
    ensure
      FileUtils.rm_rf "test-project"
    end
  end
end

private def compile_and_run_specs_on_test_project
  FileUtils.cd "test-project" do
    should_run_successfully "bin/setup"
    should_run_successfully "crystal build src/server.cr"
    should_run_successfully "crystal build src/test_project.cr"
    should_run_successfully "crystal src/app.cr"
    should_run_successfully "crystal spec"
  end
end

private def should_run_successfully(command)
  Process.run(
    command,
    shell: true,
    output: STDOUT,
    error: STDERR
  ).exit_status.should be_successful
end

private def be_successful
  eq 0
end
