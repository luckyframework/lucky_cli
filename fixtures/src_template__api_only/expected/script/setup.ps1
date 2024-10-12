# Exit if any subcommand fails
$ErrorActionPreferences = "Stop"

.\script\helpers\text_helpers.ps1


Notice "Running System Check"
& .\script\system_check.ps1
PrintDone


Notice "Installing shards"
shards install --ignore-crystal-version | Indent

if (!Test-Path ".env") {
  Notice "No .env found. Creating one."
  New-Item ".env"
  PrintDone
}

Notice "Creating the database"
lucky db.create | Indent

Notice "Verifying postgres connection"
lucky db.verify_connection | Indent

Notice "Migrating the database"
lucky db.migrate | Indent

Notice "Seeding the database with required and sample records"
lucky db.seed.required_data | Indent
lucky db.seed.sample_data | Indent

PrintDone
Notice "Run 'lucky dev' to start the app"
