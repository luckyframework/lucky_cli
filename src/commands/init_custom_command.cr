class InitCustomCommand < ACON::Command
  def configure : Nil
    name "init:custom"

    aliases "init.custom"

    description "Generate a new Lucky application"
  end

  def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
    ACON::Command::Status::SUCCESS
  end
end
