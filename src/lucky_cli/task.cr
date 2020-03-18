abstract class LuckyCli::Task
  macro inherited
    PARSER_OPTS = [] of Symbol
    @positional_arg_count : Int32 = 0
    property option_parser : OptionParser = OptionParser.new

    {% if !@type.abstract? %}
      LuckyCli::Runner.tasks << self.new
    {% end %}

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
        \{% for opt in @type.constant(:PARSER_OPTS) %}
        set_opt_for_\{{ opt.id }}(args)
        \{% end %}
        option_parser.parse(args)
        call
      end
    end

    private def wants_help_message?(args)
      args.any? { |arg| {"--help", "-h", "help"}.includes?(arg) }
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

  macro positional_arg(arg_name, description, required = nil, format = nil, to = nil)
    {% PARSER_OPTS << arg_name %}
    @{{ arg_name.id }} : {% if to %}Array(String){% else %}String{% end %} | Nil

    def set_opt_for_{{ arg_name.id }}(args : Array(String))
      {% if to %}
        value = args[@positional_arg_count..-1]
      {% else %}
        value = args[@positional_arg_count]?
      {% end %}
      {% if format %}
      matches = value.is_a?(Array) ? value.all?(&.=~({{ format }})) : value =~ {{ format }}
      if matches
        @{{ arg_name.id }} = value
      else
        raise "Invalid format for {{ arg_name.id }}. It should match {{ format }}"
      end
      {% else %}
        @{{ arg_name.id }} = value
      {% end %}
      @positional_arg_count += 1
    end

    def {{ arg_name.id }}
      {% if required %}
        if @{{ arg_name.id }}.nil?
          raise <<-ERROR
          {{ arg_name.id }} is required, but no value was passed.
          ERROR
        end
        @{{ arg_name.id }}.not_nil!
      {% else %}
        @{{ arg_name.id }}
      {% end %}
    end
  end

  macro arg(arg_name, description, shortcut = nil, required = nil, format = nil)
    {% PARSER_OPTS << arg_name %}
    @{{ arg_name.id }} : String?

    def set_opt_for_{{ arg_name.id }}(unused_args : Array(String))
      {% if shortcut %}
      option_parser.on(
        "{{ shortcut.id }} {{ arg_name.stringify.upcase.id }}",
        "--{{ arg_name.id.stringify.underscore.gsub(/_/, "-").id }}={{ arg_name.id.stringify.upcase.id }}",
        {{ description }}
      ) do |value|
        value = value.strip
        {% if format %}
        if value =~ {{ format }}
          @{{ arg_name.id }} = value
        else
          raise "Invalid format for {{ arg_name.id }}. It should match {{ format }}"
        end
        {% else %}
          @{{ arg_name.id }} = value
        {% end %}
      end
      {% else %}
      option_parser.on(
        "--{{ arg_name.id.stringify.underscore.gsub(/_/, "-").id }}={{ arg_name.id.stringify.upcase.id }}",
        {{ description }}
      ) do |value|
        value = value.strip
        {% if format %}
        if value =~ {{ format }}
          @{{ arg_name.id }} = value
        else
          raise "Invalid format for {{ arg_name.id }}. It should match {{ format }}"
        end
        {% else %}
          @{{ arg_name.id }} = value
        {% end %}
      end
      {% end %}
    end

    def {{ arg_name.id }} : String{% if !required %}?{% end %}
      {% if required %}
        if @{{ arg_name.id }}.nil?
          raise <<-ERROR
          {{ arg_name.id }} is required, but no value was passed.

          Try this...

            --{{ arg_name.id.stringify.underscore.gsub(/_/, "-").id }}=PUT_SOME_VALUE_HERE
          ERROR
        end
        @{{ arg_name.id }}.not_nil!
      {% else %}
        @{{ arg_name.id }}
      {% end %}
    end
  end

  macro switch(arg_name, description, shortcut = nil)
    {% PARSER_OPTS << arg_name %}
    @{{ arg_name.id }} : Bool = false

    def set_opt_for_{{ arg_name.id }}(unused_args : Array(String))
      {% if shortcut %}
      option_parser.on(
        "{{ shortcut.id }}",
        "--{{ arg_name.id.stringify.underscore.gsub(/_/, "-").id }}",
        {{ description }}
      ) do
        @{{ arg_name.id }} = true
      end
      {% else %}
      option_parser.on(
        "--{{ arg_name.id.stringify.underscore.gsub(/_/, "-").id }}",
        {{ description }}
      ) do
        @{{ arg_name.id }} = true
      end
      {% end %}
    end

    def {{ arg_name.id }}? : Bool
      @{{ arg_name.id }}
    end

  end

  abstract def call
  abstract def summary
end
