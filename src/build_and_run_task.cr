# Builds and runs a file (typically tasks.cr) with the passed in args
class LuckyCli::BuildAndRunTask
  private getter tasks_file : String
  private getter args : String
  private getter temp_stdout = IO::Memory.new
  private getter temp_stderr = IO::Memory.new
  private getter tasks_binary_path = "tmp/tasks_binary"

  def initialize(@tasks_file, @args)
  end

  def self.call(*args, **named_args)
    new(*args, **named_args).call
  end

  def call
    FileUtils.mkdir_p("tmp")
    build_status = build_tasks_binary
    copy_temp_io_to_real_io

    if build_status.success?
      run_tasks_file
    else
      exit build_status.exit_code
    end
  end

  private def build_tasks_binary
    command = "crystal build #{tasks_file} -o #{tasks_binary_path}"
    command += " --error-trace" if args.includes?("--error-trace")

    with_spinner("Compiling...") do
      Process.run(
        command,
        shell: true,
        input: STDIN,
        output: temp_stdout,
        error: temp_stderr
      )
    end
  end

  # STDOUT/STDERR needs to be printed after the tasks binary is built,
  # otherwise the spinner will overwrite the output from building the binary
  # (like if there is a compilation error when building).
  #
  # By creating "fake" io with IO::Memory we can collect the output and then
  # print it after the build is finished.
  private def copy_temp_io_to_real_io
    STDOUT.print(temp_stdout.to_s)
    STDERR.print(temp_stderr.to_s)
  end

  private def run_tasks_file
    exit Process.run(
      "#{tasks_binary_path} #{args}",
      shell: true,
      input: STDIN,
      output: STDOUT,
      error: STDERR
    ).exit_code
  end

  private def with_spinner(start_text)
    if ENV.has_key?("CI")
      STDERR.puts start_text.colorize.bold
      yield
    else
      LuckyCli::Spinner.start(start_text) { yield }
    end
  end
end
