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
    "Run with 'lucky my.custom_name'"
  end

  def call
  end
end

class AnotherTask < LuckyCli::Task
  summary "this should be first"

  def call
  end
end
