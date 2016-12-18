require "colorize"

args = ARGV.join(" ")

def red_arrow
  "▸".colorize(:red)
end

if File.exists?("./tasks.cr")
  Process.run "crystal run ./tasks.cr -- #{args}",
    shell: true,
    output: true,
    error: true
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
