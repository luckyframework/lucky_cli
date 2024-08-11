class TaskCommand < ACON::Command
  def configure : Nil
    name "task"
    argument("name", :required, "The provided task name")
    argument("args", :is_array, "The arguments to pass along to the task")
    usage("task <name> -- [<args>...]")
  end

  def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
    task_name = input.argument("name")
    task_args = input.argument("args", Array(String))

    style = ACON::Style::Athena.new(input, output)

    style.puts "Name: #{task_name}"
    style.puts "Args: #{task_args.inspect}"

    if File::Info.executable?("./bin/lucky.#{task_name}")
      style.puts "run old process"
    else
      style.puts "run new lua process"
    end

    ACON::Command::Status::SUCCESS
  end
end
