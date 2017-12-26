class LuckyCli::Dev < LuckyCli::Task
  banner "Run Procfile.dev using 'heroku local'"

  def call
    Process.run "heroku", ["local", "--procfile", "Procfile.dev"],
      output: STDOUT,
      error: STDERR,
      shell: true
  end
end
