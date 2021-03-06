class LuckyCli::Dev < LuckyTask::Task
  summary "Start your app with a process runner and Procfile.dev"

  def call(process_runner = LuckyCli::ProcessRunner)
    process_runner.start
  end
end
