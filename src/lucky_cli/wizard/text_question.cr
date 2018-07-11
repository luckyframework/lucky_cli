class LuckyCli::Wizard::TextQuestion
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
    else
      answer
    end
  end
end
