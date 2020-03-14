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

class TaskWithParam < LuckyCli::Task
  summary "This task has a param"
  param model_name

  def call
    model_name
  end
end

class TaskWithFormattedParam < LuckyCli::Task
  summary "This task has a param with a format"
  @[ParamFormat(/^[A-Z]/)]
  param model_name

  def call
    model_name
  end
end

class TaskWithMultipleParams < LuckyCli::Task
  summary "This is a task with multiple params. Some formatted"

  @[ParamFormat(/\d+/)]
  param looks_like_a_number

  param taco_or_whatever

  def call
    "I have #{looks_like_a_number} of #{taco_or_whatever}"
  end
end
