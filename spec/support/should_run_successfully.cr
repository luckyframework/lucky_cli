module ShouldRunSuccessfully
  private def should_run_successfully(command) : Nil
    result = Process.run(
      command,
      shell: true,
      env: ENV.to_h,
      output: STDOUT,
      error: STDERR
    )

    result.exit_code.should be_successful
  end

  private def be_successful
    eq 0
  end
end
