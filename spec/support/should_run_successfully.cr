module ShouldRunSuccessfully
  private def should_run_successfully(command)
    io = IO::Memory.new
    Process.run(
      command,
      shell: true,
      output: io,
      error: STDERR
    ).exit_status.should be_successful
    io
  end

  private def be_successful
    eq 0
  end
end
