abstract class LuckyCli::Task
  macro inherited
    {% if !@type.abstract? %}
      LuckyCli::Runner.tasks << self.new
    {% end %}

    private getter params : Array(String) = [] of String

    annotation ParamFormat
    end

    def name
      "{{@type.name.gsub(/::/, ".").underscore}}"
    end

    def help_message
      <<-TEXT
      #{summary}

      Run this task with 'lucky #{name}'
      TEXT
    end

    def print_help_or_call(args : Array(String), io : IO = STDERR)
      if wants_help_message?(args)
        io.puts help_message
      else
        parse_and_store_args(args)
        call
      end
    end

    private def wants_help_message?(args)
      args.any? { |arg| {"--help", "-h", "help"}.includes?(arg) }
    end

    private def parse_and_store_args(args : Array(String))
      @params = args.select { |arg| arg.includes?(':') }
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

  # Sets a custom param option from args passed in to the task
  #
  # ```
  # # => lucky my_task model_name:User
  # class MyTask < LuckyCli::Task
  #   summary "Custom task with param"
  #   param model_name
  #
  #   def call
  #     model_name == "User"
  #   end
  # end
  # ```
  #
  # You can also use the `ParamFormat` annotation to specify a regex format for your input
  #
  # class MyTask < LuckyCli::Task
  #   @[ParamFormat(/^[A-Z]/)]
  #   param value_that_must_start_with_capital_letter
  # end
  macro param(param_name)
    def {{param_name.id}} : String?
      found = params.find {|param| param.includes?("{{param_name.id}}") }
      if found
        value = found.split(':').last
        \{% if @def.annotation(ParamFormat) %}
          if value =~ \{{ @def.annotation(ParamFormat)[0] }}
            value
          else
            raise "Invalid param value passed to {{param_name.id}}"
          end
        \{% else %}
          value
        \{% end %}
      end
    end
  end

  abstract def call
  abstract def summary
end
