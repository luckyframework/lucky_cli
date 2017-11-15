require "../spec_helper"

describe LuckyCli::Runner do
  it "adds tasks to the runner when task classes are created" do
    LuckyCli::Runner.tasks.map(&.name).should eq [
      "another_task",
      "my.cool_task",
      "some.other.task",
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

  it "does not call the task if no args passed" do
    LuckyCli::Runner
      .run(args: [] of String)
      .should_not have_called_my_cool_task
  end

  it "does not call the task task is not found" do
    LuckyCli::Runner
      .run(args: ["not.real"])
      .should_not have_called_my_cool_task
  end
end

private def have_called_my_cool_task
  eq :my_cool_task_was_called
end
