class LabeledChoiceQuestion
  getter question_text : String
  getter choices : Array(String)

  def initialize(@question_text : String, @choices : Array(String))
  end

  def self.ask(*args, **named_args) : String
    new(*args, **named_args).ask
  end

  def ask : String
    print question_text.colorize.bold.to_s + " (#{choices.join("/")})? ".colorize.green.bold.to_s
    answer = gets.try(&.strip.gsub("'", "").downcase)
    if choices.includes?(answer)
      answer.to_s
    else
      puts "\nMust be one of: #{choices.join(", ")}".colorize.red
      ask
    end
  end
end
