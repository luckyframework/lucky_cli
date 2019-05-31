require "../spec_helper"

describe LuckyCli::Runner do
  it "adds tasks to the runner when task classes are created" do
    LuckyCli::Runner.tasks.map(&.name).reject(&.==("lucky_cli.dev")).should eq [
      "another_task",
      "my.cool_task",
      "my.custom_name",
    ]
  end

  it "lists all the available tasks" do
    LuckyCli::Runner.tasks.map(&.name).each do |name|
      LuckyCli::Runner.tasks_list.should contain(name)
    end
  end

  it "calls the task if one is found" do
    LuckyCli::Runner
      .run(args: ["my.cool_task"])
      .should have_called_my_cool_task
  end

  it "prints the help_message for a found task when a help flag is passed" do
    %w(--help -h help).each do |help_arg|
      io = IO::Memory.new
      LuckyCli::Runner.run(args: ["my.cool_task", help_arg], io: io)
      io.to_s.chomp.should have_default_help_message
    end
  end

  it "prints a custom help_message when set" do
    io = IO::Memory.new
    LuckyCli::Runner.run(args: ["my.custom_name", "-h"], io: io)
    io.to_s.chomp.should eq "Custom help message"
  end

  it "still calls a found task with non-help options" do
    LuckyCli::Runner
      .run(args: ["my.cool_task", "Taco", "--with-guac"])
      .should have_called_my_cool_task
  end

  it "does not call the task if no args passed" do
    LuckyCli::Runner
      .run(args: [] of String)
      .should_not have_called_my_cool_task
  end

  it "does not call the task task is not found" do
    begin
      LuckyCli::Runner.exit_with_error_if_not_found = false

      LuckyCli::Runner
        .run(args: ["not.real"])
        .should_not have_called_my_cool_task
    ensure
      LuckyCli::Runner.exit_with_error_if_not_found = true
    end
  end
end

private def have_called_my_cool_task
  eq :my_cool_task_was_called
end

private def have_default_help_message
  eq "Run this task with 'lucky my.cool_task'"
end
