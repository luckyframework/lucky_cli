class LuckyCli::Wizard::LabeledYesNoQuestion
  getter question_text, yes_label, no_label

  def initialize(
    @question_text : String,
    @yes_label : String,
    @no_label : String
  )
  end

  def self.ask(*args, **named_args) : Bool
    new(*args, **named_args).ask
  end

  def ask : Bool
    print question_text.colorize.bold.to_s +
          " (#{yes_label}/#{no_label}): ".colorize.green.bold.to_s
    answer = gets.try(&.strip.gsub("'", ""))
    case answer
    when yes_label
      true
    when no_label
      false
    else
      puts "\nMust be '#{yes_label}' or '#{no_label}'".colorize.red
      ask
    end
  end
end
