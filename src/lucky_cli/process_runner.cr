module LuckyCli
  abstract class ProcessRunner
    RUNNERS = [] of ProcessRunner.class

    abstract def command
    abstract def start_args

    macro inherited
      RUNNERS << self
    end

    def self.start(process = Process)
      if (runner = installed_process_runners.first?)
        runner.new.start(process)
      else
        puts "No process runner could be found. Please install Overmind, Forego or Heroku CLI."
        exit 1
      end
    end

    def self.installed_process_runners
      RUNNERS.select(&.new.installed?)
    end

    def installed? : Bool
      !!Process.find_executable(command)
    end

    def start(process = Process)
      run process, start_args
    end

    private def run(process, args)
      process.run command, args,
        output: STDOUT,
        error: STDERR,
        shell: true
    end
  end

  class ProcessRunner::Overmind < ProcessRunner
    def command
      "overmind"
    end

    def start_args
      %w(start -f Procfile.dev)
    end
  end

  class ProcessRunner::Forego < ProcessRunner
    def command
      "forego"
    end

    def start_args
      %w(start -f Procfile.dev)
    end
  end

  class ProcessRunner::Heroku < ProcessRunner
    def command
      "heroku"
    end

    def start_args
      %w(local --procfile Procfile.dev)
    end
  end

  class ProcessRunner::Foreman < ProcessRunner
    def command
      "foreman"
    end

    def start_args
      %w(start -f Procfile.dev)
    end
  end
end
