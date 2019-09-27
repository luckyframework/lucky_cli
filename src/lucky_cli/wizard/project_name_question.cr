class LuckyCli::ProjectNameQuestion
  def ask : String
    name = ProjectName.new(prompt_for_project_name)

    if name.valid?
      name.to_s
    else
      puts "\n"
      puts name.validation_error_message.colorize.red
      ask
    end
  end

  private def prompt_for_project_name
    print "#{"Project name?".colorize.bold}: "

    gets.try(&.strip.gsub("'", "")) || ""
  end
end
