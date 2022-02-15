module ShouldRunSuccessfully
  private def should_run_successfully(command) : Nil
    result = Process.run(
      command,
      shell: true,
      env: ENV.to_h,
      output: input_io,
      error: output_io
    )

    result.exit_status.should be_successful
  end

  private def be_successful
    eq 0
  end

  private def input_io
    STDIN
  end

  private def output_io
    OutputIO.instance.io
  end

  private def test_io
    if Log.for("*").level == Log::Severity::Debug
      STDERR
    else
      File.open(File::NULL, "w")
    end
  end

  private def test_puts(*args)
    test_io.puts args
  end
end

class OutputIO
  getter io

  def initialize
    @io = IO::Memory.new
  end

  def self.instance
    @@instance ||= new
  end
end
