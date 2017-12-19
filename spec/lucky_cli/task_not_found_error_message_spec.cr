require "../spec_helper"

describe LuckyCli::TaskNotFoundErrorMessage do
  it "shows 'did you mean' if there is a similar task name" do
    io = IO::Memory.new

    LuckyCli::TaskNotFoundErrorMessage.print("my:col_task", io)

    io.to_s.should contain("Did you mean")
  end

  it "does not show 'did you mean' if there is no similar task name" do
    io = IO::Memory.new

    LuckyCli::TaskNotFoundErrorMessage.print("my.task", io)

    io.to_s.should_not contain("Did you mean")
  end
end
