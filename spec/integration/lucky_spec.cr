require "../integration_spec_helper"

describe "Lucky CLI", tags: ["integration", "lucky"] do
  describe "getting help" do
    it "returns the lucky CLI help message when passing the -h flag" do
      io = IO::Memory.new
      status = run_lucky("-h", shell: true, output: io)
      status.exit_status.should eq(0)
      io.to_s.should contain("Usage: lucky [command]")
    end

    describe "returns the proper help message for built-in CLI commands" do
      it "for 'tasks'" do
        io = IO::Memory.new
        status = run_lucky(
          "tasks -h",
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
          "dev -h",
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
      err = IO::Memory.new
      status = run_lucky(
        "placeholder_task -h",
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
end
