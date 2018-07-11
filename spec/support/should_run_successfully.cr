module ShouldRunSuccessfully
  private def should_run_successfully(command)
    io = IO::Memory.new
    result = Process.run(
      command,
      shell: true,
      output: io,
      error: STDERR
    )
    if result.exit_status != 0
      puts io.to_s
    end
    result.exit_status.should be_successful
    io
  end

  private def be_successful
    eq 0
  end
end
