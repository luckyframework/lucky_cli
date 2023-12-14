{% skip_file %}

require "./spec_helper"

describe "Lucky CLI" do
  describe "getting help" do
    it "returns the lucky CLI help message when passing the -h flag" do
      output = IO::Memory.new
      Process.run("crystal", [lucky_command, "-h"], output: output)
      output.rewind
      output.to_s.should contain("Usage: lucky [command]")
    end

    it "returns the proper help message for built-in CLI commands" do
      output = IO::Memory.new
      Process.run("crystal", [lucky_command, "tasks", "-h"], env: lucky_env, output: output)
      output.rewind
      output.to_s.should contain("Usage: lucky tasks")

      output = IO::Memory.new
      Process.run("crystal", [lucky_command, "dev", "-h"], env: lucky_env, output: output)
      output.rewind
      output.to_s.should contain("Usage: lucky dev")
    end

    it "returns custom help messages from custom tasks" do
      output = IO::Memory.new
      # NOTE: This must be `error` because of how the messages are printed out from the custom tasks
      # TODO: Figure out if that's correct, or needs to change
      Process.run("crystal", [lucky_command, "placeholder_task", "-h"], env: lucky_env, error: output)
      output.rewind
      output.to_s.should contain("Custom help message")
    end
  end
end

private def lucky_env : Hash(String, String)
  {"LUCKY_TASKS_FILE" => Path["spec/tasks.cr"].to_s}
end

private def lucky_command : String
  Path["src/lucky.cr"].to_s
end
