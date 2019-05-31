abstract class LuckyCli::Task
  macro inherited
    {% if !@type.abstract? %}
      LuckyCli::Runner.tasks << self.new
    {% end %}

    def name
      "{{@type.name.gsub(/::/, ".").underscore}}"
    end

    def help_message
      "Run this task with 'lucky #{name}'"
    end

    def print_help_or_call(args : Array(String), io : IO = STDERR)
      if wants_help_message?(args)
        io.puts help_message
      else
        call
      end
    end

    private def wants_help_message?(args)
      args.any? { |arg| ["--help", "-h", "help"].includes?(arg) }
    end
  end

  macro banner(banner_text)
    {% puts "DEPRECATION WARNING: LuckyCli 'banner' has been renamed to 'summary'. Please use 'summary' in #{@type.name}" %}
    summary({{banner_text}})
  end

  macro summary(summary_text)
    def summary
      {{summary_text}}
    end
  end

  # Sets a custom title for the task
  #
  # By default the name is derived from the full module and class name.
  # However if that name is not desired, a custom one can be set.
  #
  # ```
  # class Dev::Prime < LuckyCli::Task
  #   # Would be "dev.prime" by default, but we want to set it to "dev.setup":
  #   name "dev.setup"
  #   summary "Seed the development database with example data"
  #
  #   # other methods, etc.
  # end
  # ```
  macro name(name_text)
    def name
      {{name_text}}
    end
  end

  abstract def call
  abstract def summary
end
