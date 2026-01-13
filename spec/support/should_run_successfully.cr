module ShouldRunSuccessfully
  private def should_run_successfully(command, output : IO = STDOUT) : Nil
    result = Process.run(
      command,
      shell: true,
      env: ENV.to_h,
      output: output,
      error: STDERR
    )

    result.exit_code.should be_successful
  end

  private def be_successful
    eq 0
  end
end
