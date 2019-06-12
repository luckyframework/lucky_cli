require "../spec_helper"
require "../../src/dev"

private class FakeProcessRunner
  property? started : Bool = false

  def start
    self.started = true
  end
end

describe LuckyCli::Dev do
  it "uses the first process runner it finds" do
    runner = FakeProcessRunner.new
    runner.started?.should be_false

    LuckyCli::Dev.new.call(runner)

    runner.started?.should be_true
  end
end
