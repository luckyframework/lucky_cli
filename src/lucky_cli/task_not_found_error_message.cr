require "levenshtein"

class LuckyCli::TaskNotFoundErrorMessage
  def initialize(@task_name : String, @io : IO = STDERR)
  end

  def self.print(*args)
    new(*args).print
  end

  def print
    message = "Task #{@task_name.colorize(:cyan)} not found."

    similar_task_name.try do |name|
      message += " Did you mean '#{name}'?".colorize(:yellow).to_s
    end

    @io.puts message
  end

  private def similar_task_name
    Levenshtein::Finder.find @task_name,
      LuckyCli::Runner.tasks.map(&.name),
      tolerance: 4
  end
end
