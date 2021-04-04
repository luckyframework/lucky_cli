require "../src/lucky_cli"

class PlaceholderTask < LuckyTask::Task
  def call; end

  def summary; end
end

class TaskWithInput < LuckyTask::Task
  summary "this should be first"

  def call
    input = gets
    puts "input: #{input}"
  end
end

LuckyTask::Runner.run
