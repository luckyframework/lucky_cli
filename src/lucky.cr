require "colorize"
require "./lucky_cli"
require "./generators/*"
require "./dev"
require "./ensure_process_runner_installed"

include LuckyCli::TextHelpers

args = ARGV.join(" ")

private def task_name : String?
  ARGV.first?
end

private def task_precompiled? : Bool
  !task_name.nil? && File.exists?("bin/lucky/#{task_name}")
end

if task_name == "dev"
  LuckyCli::Dev.new.call
elsif task_name == "ensure_process_runner_installed"
  LuckyCli::EnsureProcessRunnerInstalled.new.call
elsif task_precompiled?
  exit Process.run(
    "bin/lucky/#{task_name}",
    shell: true,
    output: STDOUT,
    error: STDERR
  ).exit_status
elsif File.exists?("./tasks.cr")
  exit Process.run(
    "crystal run ./tasks.cr -- #{args}",
    shell: true,
    output: STDOUT,
    error: STDERR
  ).exit_status
elsif task_name == "init"
  LuckyCli::InitQuestions.run
elsif ["-v", "--version"].includes?(task_name)
  puts LuckyCli::VERSION
else
  puts <<-MISSING_TASKS_FILE

  #{"Missing tasks.cr file".colorize(:red)}

  Try this...

    #{red_arrow} Change to the directory with the tasks.cr file,
      usually your project root
    #{red_arrow} If this is a new project, run #{"lucky init".colorize(:green)} to
      create a default tasks.cr file

  MISSING_TASKS_FILE
end
