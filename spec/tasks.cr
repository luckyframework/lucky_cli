require "../lucky_cli"

class PlaceholderTask < LuckyCli::Task
  def call; end

  def banner; end
end

LuckyCli::Runner.run
