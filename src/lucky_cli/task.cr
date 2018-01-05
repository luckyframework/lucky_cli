abstract class LuckyCli::Task
  macro inherited
    LuckyCli::Runner.tasks << self.new

    def name
      "{{@type.name.gsub(/::/, ".").underscore}}"
    end
  end

  macro banner(banner_text)
    def banner
      {{banner_text}}
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
  #   banner "Seed the development database with example data"
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
  abstract def banner
end
