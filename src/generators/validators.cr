module LuckyCli::Generators::Validators::ProjectName
  extend self

  def sanitize(name)
    name.downcase.gsub(/[^a-z0-9_-]/, "_").strip('_')
  end

  def valid?(name)
    sanitize(name) == name
  end
end
