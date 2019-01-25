abstract class LuckyCli::Task
  macro inherited
    LuckyCli::Runner.tasks << self.new

    def name
      "{{@type.name.gsub(/::/, ".").underscore}}"
    end
  end

  macro banner(banner_text)
    {% puts("DEPRECATION WARNING: 'banner' has been renamed to 'summary'. This will be removed in future versions.") %}
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
  #   name "Development database primer"
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
