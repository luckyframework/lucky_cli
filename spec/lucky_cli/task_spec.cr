require "../spec_helper"

class My::CoolTask < LuckyCli::Task
  banner "This task does something awesome"

  def call
  end
end

describe LuckyCli::Task do
  it "creates a name from the class name when inheriting from LuckyCli::Task" do
    My::CoolTask.new.name.should eq "my.cool_task"
  end

  it "creates banner text" do
    My::CoolTask.new.banner.should eq "This task does something awesome"
  end
end
