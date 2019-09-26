require "../spec_helper"

include HaveDefaultHelperMessageMatcher

private abstract class ShouldNotBlowUpForAbstractClasses < LuckyCli::Task
end

describe LuckyCli::Task do
  it "creates a name from the class name when inheriting from LuckyCli::Task" do
    My::CoolTask.new.name.should eq "my.cool_task"
  end

  it "uses a specified name over the auto generated name" do
    Some::Other::Task.new.name.should eq "my.custom_name"
  end

  it "creates summary text" do
    My::CoolTask.new.summary.should eq "This task does something awesome"
  end

  it "has a default help message" do
    message = My::CoolTask.new.help_message
    message.should contain "Run this task with 'lucky my.cool_task'"
    message.should contain(My::CoolTask.new.summary)
  end

  describe "print_help_or_call" do
    it "prints the help_message for a found task when a help flag is passed" do
      %w(--help -h help).each do |help_arg|
        io = IO::Memory.new
        My::CoolTask.new.print_help_or_call(args: [help_arg], io: io)
        io.to_s.should have_default_help_message
      end
    end

    it "prints a custom help_message when set" do
      io = IO::Memory.new
      Some::Other::Task.new.print_help_or_call(args: ["-h"], io: io)
      io.to_s.chomp.should eq "Custom help message"
    end
  end
end
