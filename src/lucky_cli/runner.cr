require "colorize"
require "./text_helpers"

class LuckyCli::Runner
  @@tasks = [] of LuckyCli::Task
  class_property? exit_with_error_if_not_found = true

  extend LuckyCli::TextHelpers

  def self.tasks
    @@tasks.sort_by!(&.name)
  end

  def self.run(args = ARGV, io : IO = STDERR)
    task_name = args.shift?

    if !task_name.nil? && {"--help", "-h"}.includes?(task_name)
      puts help_text
    elsif task_name.nil?
      io.puts <<-HELP_TEXT
      Missing a task name

      To see a list of available tasks, run #{"lucky --help".colorize(:green)}
      HELP_TEXT
    else
      if task = find_task(task_name)
        task.output = io
        task.print_help_or_call(args)
      else
        TaskNotFoundErrorMessage.print(task_name)
        if exit_with_error_if_not_found?
          exit(127)
        end
      end
    end
  end

  def self.help_text
    puts <<-HELP_TEXT
    Usage: lucky name.of.task [options]

    Available tasks:

    #{tasks_list}
    HELP_TEXT
  end

  def self.find_task(task_name : String)
    @@tasks.find { |task| task.name == task_name }
  end

  def self.tasks_list
    String.build do |list|
      tasks.each do |task|
        list << ("  #{arrow} " + task.name).colorize(:green)
        list << list_padding_for(task.name)
        list << task.summary
        list << "\n"
      end
    end
  end

  def self.list_padding_for(task_name)
    " " * (longest_task_name - task_name.size + 2)
  end

  def self.longest_task_name
    tasks.map(&.name.size).max
  end
end
