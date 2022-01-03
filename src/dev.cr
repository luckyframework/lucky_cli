class LuckyCli::Dev < LuckyTask::Task
  summary "Starts your app by running the processes found in Procfile.dev"

  def call
    ::Nox.run("Procfile.dev")
  end
end
