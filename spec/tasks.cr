require "../src/lucky_cli"

class PlaceholderTask < LuckyTask::Task
  summary "placeholder"
  def call; end
end

class TaskWithInput < LuckyTask::Task
  summary "this should be first"

  def call
    input = gets
    puts "input: #{input}"
  end
end

LuckyTask::Runner.run
