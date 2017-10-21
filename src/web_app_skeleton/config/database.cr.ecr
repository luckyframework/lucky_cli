LuckyRecord::Repo.configure do
  if Lucky::Env.production?
    settings.url = ENV.fetch("DATABASE_URL")
  else
    settings.url = LuckyRecord::PostgresURL.build(
      hostname: "localhost",
      database: "constable_crystal_#{Lucky::Env.name}"
    )
  end
end

LuckyMigrator::Runner.configure do
  settings.database = "constable_crystal_#{Lucky::Env.name}"
end
