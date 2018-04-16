require "../lucky_cli"

class PlaceholderTask < LuckyCli::Task
  def call; end

  def banner; end
end

class TaskWithInput < LuckyCli::Task
  banner "this should be first"

  def call
    input = gets
    puts "input: #{input}"
  end
end

LuckyCli::Runner.run
