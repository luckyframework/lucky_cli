class LuckyCli::Wizard::YesNoQuestion
  def self.ask(question_text : String) : Bool
    LabeledYesNoQuestion.ask(question_text, yes_label: "y", no_label: "n")
  end
end
