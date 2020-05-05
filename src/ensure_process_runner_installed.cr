class LuckyCli::EnsureProcessRunnerInstalled < LuckyCli::Task
  include LuckyCli::TextHelpers

  summary "Ensures that a process runner is installed"

  def call
    if LuckyCli::ProcessRunner.installed_process_runners.empty?
      puts <<-ERROR
      #{"Missing process runner for 'lucky dev'".colorize(:red)}

      Install one of these...

        #{green_arrow} Overmind (recommended): https://github.com/DarthSim/overmind#installation
        #{green_arrow} Forego: https://github.com/ddollar/forego#installation
        #{green_arrow} Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli#download-and-install

      ERROR
      exit 1
    end
  end
end
