require "colorize"
require "option_parser"
require "ecr"
require "./lucky_cli/spinner"
require "./lucky_cli"
require "./generators/*"
require "./dev"
require "./build_and_run_task"

include LuckyTask::TextHelpers

args = ARGV.join(" ")
tasks_file = ENV.fetch("LUCKY_TASKS_FILE", Path["./tasks.cr"].to_s)
inside_app_directory = File.file?(tasks_file)

private def task_name : String?
  ARGV.first?
end

private def task_compiled? : Bool
  path = task_path
  !path.nil? && {% if compare_versions(Crystal::VERSION, "1.13.0") >= 0 %}File::Info.executable?(path){% else %}File.executable?(path){% end %}
end

private def task_path(ext : String = "") : Path?
  task_name.try do |name|
    Path.new("bin", "lucky.#{name}#{ext}")
  end
end

private def task_not_compiled? : Bool
  path = task_path(".cr")
  !path.nil? && File.file?(path)
end

private def built_in_commands : Array(String)
  ["dev", "tasks", "init", "init.custom"]
end

private def print_lucky_app_not_detected_error
  puts <<-ERROR

  #{"You are not in a Lucky project".colorize(:red)}

  Try this...

    #{red_arrow} Run #{"lucky init".colorize(:green)} to create a Lucky project.
    #{red_arrow} Change your project's root directory to see what tasks are available.

  ERROR
end

run_dev_server = false
start_wizard = false
generate_custom_app = false

options = OptionParser.new do |parser|
  parser.banner = "Usage: lucky [command]"

  if inside_app_directory
    parser.on("dev", "Boot the lucky development server") do
      run_dev_server = true
      parser.banner = "Usage: lucky dev"
      parser.on("-h", "--help", "Display lucky dev help menu") do
        puts <<-MESSAGE
        Usage: lucky dev

        Boot your Lucky application. Uses the Procfile.dev to
        run each service. Edit this file to change which services
        are booted.
        MESSAGE
        exit
      end
    end

    parser.on("tasks", "Display a list of the tasks available in your app") do
      # This passes the help flag to LuckyTask within your app to
      # generate a list of available tasks, and bypasses the help
      # flag for this parser
      args = "-h"
      parser.banner = "Usage: lucky tasks"
      parser.on("-h", "--help", "Display the lucky tasks help menu") do
        puts <<-MESSAGE
        Usage: lucky tasks

        Run this from within your Lucky application directory.
        This will compile a list of all the available tasks in your
        application.

        To compile your tasks, build the tasks.cr file
        > crystal build tasks.cr -o bin/tasks

        Then run your tasks file with your task
        > ./bin/tasks my.task -m --task=1

        MESSAGE
        exit
      end
    end

    if ARGV.size > 1 && !built_in_commands.includes?(task_name)
      # This stops the CLI parsing options beyond this point.
      # It allows args to be passed to custom CLI tasks
      parser.stop
    end
  else
    parser.on("init", "Start the Lucky wizard") do
      start_wizard = true
      parser.banner = "Usage: lucky init"
      parser.on("-h", "--help", "Display lucky init help menu") do
        puts <<-MESSAGE
        Usage: lucky init

        Run this to start the new application wizard.
        MESSAGE
        exit
      end
    end

    parser.on("init.custom", "Generate a new Lucky application") do
      generate_custom_app = true
      # This command handles its own CLI arg parsing
      LuckyCli::InitCustom.run
    end
  end

  parser.on("-v", "--version", "Show the version of the LuckyCLI") do
    puts LuckyCli::VERSION
    exit
  end

  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end

  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

options.parse

if run_dev_server
  if File.file?("Procfile.dev")
    LuckyCli::Dev.new.call
  else
    print_lucky_app_not_detected_error
  end
elsif start_wizard
  LuckyCli::Init.run
elsif generate_custom_app
  # already running
elsif task_compiled?
  exit Process.run(
    task_path.to_s,
    ARGV.skip(1),
    shell: true,
    input: STDIN,
    output: STDOUT,
    error: STDERR
  ).exit_code
elsif task_not_compiled?
  crystal_command = {% if flag?(:windows) %}"crystal.exe"{% else %}"crystal"{% end %}
  exit Process.run(
    crystal_command,
    [task_path(".cr").to_s] + ARGV.skip(1),
    shell: true,
    input: STDIN,
    output: STDOUT,
    error: STDERR
  ).exit_code
elsif inside_app_directory
  # Run task from tasks.cr file since this task is not precompiled
  LuckyCli::BuildAndRunTask.call(tasks_file, args)
else
  print_lucky_app_not_detected_error
end
