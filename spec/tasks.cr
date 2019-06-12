require "../src/lucky_cli"

class PlaceholderTask < LuckyCli::Task
  def call; end

  def summary; end
end

class TaskWithInput < LuckyCli::Task
  summary "this should be first"

  def call
    input = gets
    puts "input: #{input}"
  end
end

LuckyCli::Runner.run
