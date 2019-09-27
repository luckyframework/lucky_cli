class LuckyCli::ProjectName
  getter name
  delegate empty?, to: name

  def initialize(@name : String)
  end

  def to_s(io)
    io << name
  end

  def valid? : Bool
    (sanitized_name == name) && !empty?
  end

  def validation_error_message : String
    if empty?
      <<-TEXT
      Project name can't be blank
      TEXT
    else
      <<-TEXT
      Project name should only contain lowercase letters, numbers, underscores, and dashes.

      How about: '#{sanitized_name}'?
      TEXT
    end
  end

  def sanitized_name
    name.downcase.gsub(/[^a-z0-9_-]/, "_").strip('_')
  end
end
