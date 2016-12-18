require "../spec_helper"

class My::Cool::Task < LuckyCli::Task
  banner "foo"

  def call
    :my_cool_task_was_called
  end
end

class Some::Other::Task < LuckyCli::Task
  banner "bar"

  def call
  end
end

describe LuckyCli::Runner do
  it "adds tasks to the runner when task classes are created" do
    LuckyCli::Runner.tasks.map(&.name).should eq [
      "my.cool.task",
      "some.other.task",
    ]
  end

  it "lists all the available tasks" do
    LuckyCli::Runner.tasks_list.should eq <<-TASK_LIST
    my.cool.task     -> foo
    some.other.task  -> bar

    TASK_LIST
  end

  it "calls the task if one is found" do
    LuckyCli::Runner
      .run(args: ["my.cool.task"])
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
