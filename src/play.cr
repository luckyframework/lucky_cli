class LuckyCli::Play < LuckyCli::Task
  banner "Loads the app into 'crystal play'"

  def call
    Process.run "crystal", ["play", "src/app.cr"],
      error: true,
      output: true,
      shell: true
  end
end
