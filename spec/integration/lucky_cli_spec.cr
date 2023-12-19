require "../spec_helper"

describe "Lucky CLI", tags: "integration" do
  describe "running a task", tags: "task" do
    it "runs precompiled tasks" do
      io = IO::Memory.new
      status = run_lucky(
        args: %w[hello_world],
        shell: true,
        output: io
      )
      status.exit_status.should eq(0)
      io.to_s.should eq("Hello World!\n")
    end

    it "allows tasks to accept input from STDIN" do
      io = IO::Memory.new
      run_lucky(
        args: %w[task_with_input],
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

  describe "getting help", tags: "lucky" do
    it "returns the lucky CLI help message when passing the -h flag" do
      io = IO::Memory.new
      status = run_lucky(args: %w[-h], shell: true, output: io)
      status.exit_status.should eq(0)
      io.to_s.should contain("Usage: lucky [command]")
    end

    describe "returns the proper help message for built-in CLI commands" do
      it "for 'tasks'" do
        io = IO::Memory.new
        status = run_lucky(
          args: %w[tasks -h],
          shell: true,
          output: io,
          env: {
            "LUCKY_TASKS_FILE" => fixtures_tasks_path.to_s,
          }
        )
        status.exit_status.should eq(0)
        io.to_s.should contain("Usage: lucky tasks")
      end

      it "for 'dev'" do
        io = IO::Memory.new
        status = run_lucky(
          args: %w[dev -h],
          shell: true,
          output: io,
          env: {
            "LUCKY_TASKS_FILE" => fixtures_tasks_path.to_s,
          }
        )
        status.exit_status.should eq(0)
        io.to_s.should contain("Usage: lucky dev")
      end
    end

    # NOTE: This must be `error` because of how the messages are printed out from the custom tasks
    # TODO: Figure out if that's correct, or needs to change
    it "returns custom help messages from custom tasks" do
      io = IO::Memory.new
      status = run_lucky(
        args: %w[placeholder_task -h],
        shell: true,
        error: io,
        env: {
          "LUCKY_TASKS_FILE" => fixtures_tasks_path.to_s,
        }
      )
      status.exit_status.should eq(0)
      io.to_s.should contain("Custom help message")
    end
  end

  describe "custom init", tags: "init" do
    around_each do |example|
      with_tempfile("tmp") do |tmp|
        Dir.mkdir_p(tmp)
        Dir.cd(tmp) do
          example.run
        end
      end
    end

    it "does not create project if directory with same name already exist" do
      FileUtils.mkdir("test-project")
      io = IO::Memory.new
      status = run_lucky(
        args: %w[init.custom test-project],
        shell: true,
        output: io
      )
      status.exit_status.should eq(0)
      io.to_s.should contain("Folder named test-project already exists, please use a different name")
    end

    it "does not create project if project name is not a valid project name" do
      io = IO::Memory.new
      status = run_lucky(
        args: %w[init.custom 'test\ project'],
        shell: true,
        output: io
      )
      status.exit_status.should_not eq(0)
      io.to_s.should contain("Project name should only contain lowercase letters, numbers, underscores, and dashes.")
    end

    it "does not create project if the project name is reserved" do
      io = IO::Memory.new
      status = run_lucky(
        args: %w[init.custom 'app'],
        shell: true,
        output: io
      )
      status.exit_status.should_not eq(0)
      io.to_s.should contain("Projects cannot be named app, app_database, app_server, shards, start_server.")
    end
  end
end
