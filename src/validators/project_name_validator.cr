class ProjectNameValidator
  def self.call(input)
    sanitized_input = input.downcase.gsub(/[^a-z0-9_-]/, "_").strip('_')
    reserved_project_names = %w[app app_database app_server shards start_server]

    if input.empty?
      raise ArgumentError.new("Project name can't be blank")
    elsif reserved_project_names.includes?(sanitized_input)
      raise ArgumentError.new(<<-TEXT)
      Projects cannot be named #{reserved_project_names.join(", ")}.

      How about: 'my_lucky_app'?
      TEXT
    elsif sanitized_input != input
      raise ArgumentError.new(<<-TEXT)
      Project name should only contain lowercase letters, numbers, underscores, and dashes.

      How about: '#{sanitized_input}'?
      TEXT
    end

    input
  end
end
