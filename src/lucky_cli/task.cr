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

  abstract def call
  abstract def banner
end
