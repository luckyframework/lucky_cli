class LuckyCli::Dev < LuckyCli::Task
  banner "Run Procfile.dev using 'heroku local'"

  def call
    Process.run "heroku", ["local", "--procfile", "Procfile.dev"],
      error: true,
      output: true,
      shell: true
  end
end
