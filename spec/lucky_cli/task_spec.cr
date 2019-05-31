require "../spec_helper"

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
    My::CoolTask.new.help_message.should eq "Run this task with `lucky my.cool_task`"
  end
end
