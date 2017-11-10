require "../spec_helper"

describe "Initializing a new web project" do
  it "creates the project successfully" do
    puts "Running integration spec. This might take awhile...".colorize(:yellow)
    should_run_successfully "rm -rf ./test-project"
    should_run_successfully "crystal src/lucky.cr init test-project"
    FileUtils.cd "test-project" do
      should_run_successfully "crystal build src/server.cr"
      should_run_successfully "crystal build src/test_project.cr"
      should_run_successfully "crystal src/app.cr"
    end
    FileUtils.rm_r "test-project"
  end

  it "does not create project if directory with same name already exist" do
    FileUtils.mkdir "test-project"
    output = IO::Memory.new
    Process.run(
      "crystal src/lucky.cr init test-project",
      output: output,
      shell: true
    )
    FileUtils.rm_r "test-project"
    message = "Folder with test-project already exists, please use a different name"
    output.to_s.strip.should eq(message)
  end
end

private def should_run_successfully(command)
  Process.run(
    command,
    shell: true,
    output: true,
    error: true
  ).exit_status.should be_succeful
end

private def be_succeful
  eq 0
end
