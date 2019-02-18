Lucky::LogHandler.configure do |settings|
  settings.show_timestamps = Lucky::Env.production?
  settings.enabled = !Lucky::Env.test?
end
