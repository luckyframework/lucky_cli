require "../src/lucky_cli"

class PlaceholderTask < LuckyTask::Task
  summary "placeholder"
  help_message "Custom help message"
  switch :test_mode, "Run in test mode."

  def call
    output.puts "Calling Placeholder. Test: #{test_mode?}"
  end
end

class TaskWithInput < LuckyTask::Task
  summary "this should be first"

  def call
    input = gets
    puts "input: #{input}"
  end
end

LuckyTask::Runner.run
