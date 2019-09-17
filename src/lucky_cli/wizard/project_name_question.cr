class LuckyCli::Wizard::ProjectNameQuestion
  getter question_text

  def initialize(@question_text : String)
  end

  def self.ask(*args, **named_args) : String
    new(*args, **named_args).ask
  end

  def ask : String
    print question_text.colorize.bold.to_s + " "
    answer = gets.try(&.strip.gsub("'", "")) || ""
    if answer.empty?
      puts "Can't be empty".colorize.yellow.bold
      ask
    elsif valid?(answer)
      return answer
    else
      message = <<-TEXT
      Project name should only contain lowercase letters, numbers, underscores, and dashes.

      How about: '#{sanitize(answer)}'?
      TEXT

      puts message.colorize(:yellow)
      ask
    end
  end

  def sanitize(name)
    name.downcase.gsub(/[^a-z0-9_-]/, "_").strip('_')
  end

  def valid?(name)
    sanitize(name) == name
  end
end
