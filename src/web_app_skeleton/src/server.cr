require "./app"

if Lucky::Env.development?
  LuckyMigrator::Runner.new.ensure_migrated!
end
Habitat.raise_if_missing_settings!

app = App.new
puts "Listening on #{app.base_uri}"
app.listen

Signal::INT.trap do
  app.close
end
