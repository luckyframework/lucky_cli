require "colorize"
require "./lucky_cli"
require "./generators/*"
require "./dev"
require "./ensure_process_runner_installed"

include LuckyCli::TextHelpers

args = ARGV.join(" ")

if ARGV.first? == "dev"
  LuckyCli::Dev.new.call
elsif ARGV.first? == "ensure_process_runner_installed"
  LuckyCli::EnsureProcessRunnerInstalled.new.call
elsif File.exists?("./tasks.cr")
  Process.run "crystal run ./tasks.cr --no-debug -- #{args}",
    shell: true,
    output: STDOUT,
    error: STDERR
elsif ARGV.first? == "init"
  LuckyCli::InitQuestions.run
elsif ["-v", "--version"].includes?(ARGV.first?)
  puts LuckyCli::VERSION
else
  puts <<-MISSING_TASKS_FILE

  #{"Missing tasks.cr file".colorize(:red)}

  Try this...

    #{red_arrow} Change to the directory with the task.cr file,
      usually your project root
    #{red_arrow} If this is a new project, run #{"lucky init".colorize(:green)} to
      create a default tasks.cr file

  MISSING_TASKS_FILE
end
