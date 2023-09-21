require "../integration_spec_helper"

describe "Running a task", tags: ["integration", "task"] do
  it "runs precompiled tasks" do
    io = IO::Memory.new
    status = run_lucky("hello_world", shell: true, output: io)
    status.exit_status.should eq(0)
    io.to_s.should eq("Hello World!\n")
  end

  it "allows tasks to accept input from STDIN" do
    io = IO::Memory.new
    run_lucky(
      "task_with_input",
      shell: true,
      input: IO::Memory.new("hello world"),
      output: io,
      env: {
        "LUCKY_TASKS_FILE" => fixtures_tasks_path.to_s,
      }
    )
    io.to_s.should eq("input: hello world\n")
  end
end

# TODO: test lucky command failures
# it "does not create project if directory with same name already exist" do
# FileUtils.mkdir "test-project"
# output = IO::Memory.new
# Process.run(
# "crystal run src/lucky.cr -- init.custom test-project",
# output: output,
# shell: true
# )
# message = "Folder named test-project already exists, please use a different name"
# output.to_s.strip.should contain(message)
# FileUtils.rm_rf "test-project"
# end

# it "does not create project if project name is not a valid project name" do
# output = IO::Memory.new
# Process.run(
# "crystal run src/lucky.cr -- init.custom 'test project'",
# env: ENV.to_h,
# output: output,
# shell: true
# )
# message = "Project name should only contain lowercase letters, numbers, underscores, and dashes."
# output.to_s.strip.should contain(message)
# end

# it "does not create project if the project name is reserved" do
# output = IO::Memory.new
# Process.run(
# "crystal run src/lucky.cr -- init.custom 'app'",
# env: ENV.to_h,
# output: output,
# shell: true
# )
# message = "Projects cannot be named app, app_database, app_server, shards, start_server."
# output.to_s.strip.should contain(message)
# end
