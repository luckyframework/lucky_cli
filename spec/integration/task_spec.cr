require "../spec_helper"

describe "Running a task" do
  it "returns a non-zero exit code when running a missing task" do
    task("missing.task").exit_status.should_not be_successful
  end
end

private def run(process)
  Process.run(
    process,
    shell: true,
    output: true,
    error: true
  )
end

private def task(task_name)
  run("crystal spec/tasks.cr --no-debug -- #{task_name}")
end

private def be_successful
  eq 0
end
