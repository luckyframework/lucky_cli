require "../spec_helper"

describe "Running a task" do
  it "returns a non-zero exit code when running a missing task" do
    task("missing.task").exit_status.should_not be_successful
  end

  it "runs precompiled tasks" do
    io = IO::Memory.new

    run("crystal src/lucky.cr precompiled_task", output: io)

    io.to_s.should eq "Ran precompiled task\n"
  end

  it "allows tasks to accept input from STDIN" do
    io = IO::Memory.new

    run("echo 'hello world' | LUCKY_TASKS_FILE=./spec/tasks.cr crystal src/lucky.cr task_with_input", output: io)

    io.to_s.should eq "input: hello world\n"
  end
end

private def run(process, output = STDOUT)
  Process.run(
    process,
    shell: true,
    output: output,
    error: STDERR
  )
end

private def task(task_name)
  run("crystal spec/tasks.cr --no-debug -- #{task_name}")
end

private def be_successful
  eq 0
end
