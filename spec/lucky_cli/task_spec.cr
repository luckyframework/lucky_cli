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

  describe "with command line args" do
    it "creates methods for the args and returns their values" do
      task = TaskWithArgs.new.print_help_or_call(args: ["--model-name=User", "--model-type=Polymorphic"]).not_nil!
      task.model_name.should eq "User"
      task.model_type.should eq "Polymorphic"
    end

    it "allows the args to be optional and use shortcuts" do
      task = TaskWithArgs.new.print_help_or_call(args: ["-m User"]).not_nil!
      task.model_name.should eq "User"
      task.model_type.should eq nil
    end

    it "raises an error when an arg is required and not passed" do
      task = TaskWithRequiredFormatArgs.new.print_help_or_call(args: [""]).not_nil!
      expect_raises(Exception, /--theme=SOME_VALUE/) do
        task.theme
      end
    end

    it "raises an error if the value doesn't match the format" do
      expect_raises(Exception, /Invalid format for theme/) do
        TaskWithRequiredFormatArgs.new.print_help_or_call(args: ["--theme=Spooky"])
      end
    end

    it "creates methods for switch flags that default to false" do
      task = TaskWithSwitchFlags.new.print_help_or_call(args: ["-a"]).not_nil!
      task.force?.should eq false
      task.admin?.should eq true
    end

    it "allows the args to be positional with no flags" do
      task = TaskWithPositionalArgs.new.print_help_or_call(args: ["User", "name:String", "email:String"]).not_nil!
      task.model.should eq "User"
      task.columns.should eq ["name:String", "email:String"]
    end

    it "raises an error if the positional arg doesn't match the format" do
      expect_raises(Exception, /Invalid format for columns/) do
        TaskWithPositionalArgs.new.print_help_or_call(args: ["User", "name"])
      end
    end
  end
end
