database_name = "test_project_#{LuckyEnv.environment}"

AppDatabase.configure do |settings|
  if LuckyEnv.production?
    settings.credentials = Avram::Credentials.parse(ENV["DATABASE_URL"])
  else
    settings.credentials = Avram::Credentials.parse?(ENV["DATABASE_URL"]?) || Avram::Credentials.new(
      database: database_name,
      hostname: ENV["DB_HOST"]? || "localhost",
      port: ENV["DB_PORT"]?.try(&.to_i) || 5432,
      # Some common usernames are "postgres", "root", or your system username (run 'whoami')
      username: ENV["DB_USERNAME"]? || "postgres",
      # Some Postgres installations require no password. Use "" if that is the case.
      password: ENV["DB_PASSWORD"]? || "postgres"
    )
  end
end

Avram.configure do |settings|
  settings.database_to_migrate = AppDatabase

  # In production, allow lazy loading (N+1).
  # In development and test, raise an error if you forget to preload associations
  settings.lazy_load_enabled = LuckyEnv.production?

  # Always parse `Time` values with these specific formats.
  # Used for both database values, and datetime input fields.
  # settings.time_formats << "%F"
end
