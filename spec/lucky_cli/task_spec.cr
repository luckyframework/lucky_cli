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
        task = My::CoolTask.new
        task.output = IO::Memory.new
        task.print_help_or_call(args: [help_arg])
        task.output.to_s.should have_default_help_message
      end
    end

    it "prints a custom help_message when set" do
      task = Some::Other::Task.new
      task.output = IO::Memory.new
      task.print_help_or_call(args: ["-h"])
      task.output.to_s.chomp.should eq "Custom help message"
    end
  end

  describe "with command line args" do
    it "creates methods for the args and returns their values" do
      task = TaskWithArgs.new.print_help_or_call(args: ["--model-name=User", "--model-type=Polymorphic"]).not_nil!
      task.model_name.should eq "User"
      task.model_type.should eq "Polymorphic"
    end

    it "allows the args to be optional" do
      task = TaskWithArgs.new.print_help_or_call(args: ["--model-name=User"]).not_nil!
      task.model_name.should eq "User"
      task.model_type.should eq nil
    end

    it "allows using an arg shortcut" do
      task = TaskWithArgs.new.print_help_or_call(args: ["-m User"]).not_nil!
      task.model_name.should eq "User"
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

    it "provides an example for the error message on args" do
      expect_raises(Exception, /Example: dark/) do
        TaskWithRequiredFormatArgs.new.print_help_or_call(args: ["--theme=Spooky"])
      end
    end

    it "sets switch flags that default to false" do
      task = TaskWithSwitchFlags.new.print_help_or_call(args: [] of String).not_nil!
      task.admin?.should eq false
    end

    it "sets switch flags from args" do
      task = TaskWithSwitchFlags.new.print_help_or_call(args: ["-a"]).not_nil!
      task.admin?.should eq true
    end

    it "allows positional args that do not require a flag name" do
      task = TaskWithPositionalArgs.new.print_help_or_call(args: ["User", "name:String", "email:String"]).not_nil!
      task.model.should eq "User"
      task.columns.should eq ["name:String", "email:String"]
    end

    it "raises an error if the positional arg doesn't match the format" do
      expect_raises(Exception, /Invalid format for model/) do
        TaskWithPositionalArgs.new.print_help_or_call(args: ["user", "name"])
      end
    end

    it "provides an example for the error message on positional_arg" do
      expect_raises(Exception, /Example: name:String/) do
        TaskWithPositionalArgs.new.print_help_or_call(args: ["User", "name"])
      end
    end
  end

  describe "output" do
    it "allows you to specify where the output is written to" do
      task = TaskWithFancyOutput.new
      task.output = IO::Memory.new

      task.call
      task.output.to_s.should contain "Fancy output"
    end
  end
end
