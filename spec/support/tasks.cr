class My::CoolTask < LuckyCli::Task
  summary "This task does something awesome"

  def call
    :my_cool_task_was_called
  end
end

class Some::Other::Task < LuckyCli::Task
  summary "bar"
  name "my.custom_name"

  def help_message
    "Custom help message"
  end

  def call
  end
end

class AnotherTask < LuckyCli::Task
  summary "this should be first"

  def call
  end
end

class TaskWithArgs < LuckyCli::Task
  summary "This task has CLI args"
  arg :model_name, "This is the name of the model", shortcut: "-m", optional: true
  arg :model_type, description: "Define the model type", optional: true

  def call
    self
  end
end

class TaskWithRequiredFormatArgs < LuckyCli::Task
  summary "This task has a required arg with a format"
  arg :theme,
    description: "Specifies which theme to use. Must be dark or light",
    format: /^(dark|light)$/,
    example: "dark"

  def call
    self
  end
end

class TaskWithSwitchFlags < LuckyCli::Task
  summary "This is a task with switch flags"

  switch :force, "Use the force."
  switch :admin, description: "Set an admin?", shortcut: "-a"

  def call
    self
  end
end

class TaskWithPositionalArgs < LuckyCli::Task
  summary "This is a task with positional args"

  positional_arg :model, "Define the model", format: /^[A-Z]/
  positional_arg :columns,
    "Define the columns like name:String",
    to_end: true,
    format: /\w+:[A-Z]\w+(::\w+)?/,
    example: "name:String"

  def call
    self
  end
end

class TaskWithFancyOutput < LuckyCli::Task
  summary "This is a task with some fancy output"

  def call
    output.puts "Fancy output".colorize.green
    self
  end
end
