class My::CoolTask < LuckyCli::Task
  banner "This task does something awesome"

  def call
    :my_cool_task_was_called
  end
end

class Some::Other::Task < LuckyCli::Task
  banner "bar"
  name "my.custom_name"

  def call
  end
end

class AnotherTask < LuckyCli::Task
  banner "this should be first"

  def call
  end
end
