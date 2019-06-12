require "../spec_helper"

private class FakeProcess
  property command : String?
  property args : Array(String)?

  def run(command, args, output, error, shell)
    self.command = command
    self.args = args
  end
end

private class FakeProcessRunner < LuckyCli::ProcessRunner
  def command
    "foo"
  end

  def start_args
    ["bar"]
  end
end

private class InstalledRunner < LuckyCli::ProcessRunner
  def command
    "crystal"
  end

  def start_args
    ["bar"]
  end
end

private class MissingRunner < LuckyCli::ProcessRunner
  def command
    "not_a_real_command"
  end

  def start_args
    ["bar"]
  end
end

describe LuckyCli::ProcessRunner do
  it "can be started" do
    process = FakeProcess.new

    FakeProcessRunner.new.start(process)

    process.command.should eq "foo"
    process.args.should eq ["bar"]
  end

  it "knows if it is installed or not" do
    InstalledRunner.new.installed?.should be_true
    MissingRunner.new.installed?.should be_false
  end

  it "can find an installed process runner and start it" do
    process = FakeProcess.new

    LuckyCli::ProcessRunner.start(process)

    process.command.not_nil!.empty?.should be_false
  end
end
