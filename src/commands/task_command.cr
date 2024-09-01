require "./task/*"

class TaskCommand < ACON::Command
  def configure : Nil
    name "task"

    description "Run a task"

    argument "name", :required
    argument "args", :is_array
    option "debug", "d", description: "Turn on debugging flags (default: --error-trace)", value_mode: :optional, default: "--error-trace"
    option "experimental", "x", description: "Experimental Lua support"

    usage "<name> -- [<args>...]"
    usage "my.task"
    usage "my.task -- --greeting=Hello"
  end

  def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
    style = ACON::Style::Athena.new(input, output)

    task_name = input.argument("name", String)
    task_args = input.argument("args", Array(String))
    precompiled_task_path = Path["bin/lucky.#{task_name}"]

    if File::Info.executable?(precompiled_task_path)
      execute_process(precompiled_task_path.to_s, task_args)
    elsif input.option("experimental", Bool)
      begin
        LuaLucky.run
        ACON::Command::Status::SUCCESS
      rescue error
        raise error
        ACON::Command::Status::FAILURE
      end
    else
      build_and_run_task(task_name, task_args, input, output)
    end
  end

  private def execute_process(command : String, args : Array(String)) : ACON::Command::Status
    status = Process.run(command, args: args, shell: true, input: STDIN, output: STDOUT, error: STDERR)
    ACON::Command::Status.new(status.exit_code)
  end

  private def build_and_run_task(task_name, task_args, input, output)
    tasks_file_path = Path[ENV.fetch("LUCKY_TASKS_FILE", "tasks.cr")]
    tempfile = File.tempfile(task_name)
    tempfile_path = tempfile.path.to_s

    cmd = "crystal"
    args = ["build", tasks_file_path.to_s]
    args << input.option("debug", String)
    args += ["-o", tempfile.path]

    indicator_values = %w[⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷].map(&.colorize(:green).to_s)

    indicator = ACON::Helper::ProgressIndicator.new(output, indicator_values: indicator_values)

    indicator.start "Compiling...".colorize.bold.to_s
    running = true

    process = Process.new(cmd, args: args, shell: true, input: STDIN, output: STDOUT, error: STDERR)

    spawn do
      while running
        indicator.advance
        Fiber.yield
      end
    end

    status = process.wait
    running = false
    tempfile.close

    indicator.finish "Compiled!".colorize.bold.to_s

    unless status.success?
      return ACON::Command::Status.new(status.exit_code)
    end

    cmd = tempfile_path
    args = [task_name]
    args += task_args

    execute_process(cmd, args).tap do
      File.delete(tempfile_path)
    end
  end
end
