require "./helpers/*"

notice "Running System Check"

require "./system_check"

print_done

notice "Installing node dependencies"
run_command "yarn", "install", "--no-progress"

print_done

notice "Installing shards"
run_command "shards", "install"

if !File.exists?(".env")
  notice "No .env found. Creating one."
  File.touch ".env"
  print_done
end

notice "Setting up the database"

run_command "lucky", "db.setup"

notice "Seeding the database with required and sample records"
run_command "lucky", "db.seed.required_data"
run_command "lucky", "db.seed.sample_data"

print_done
notice "Run 'lucky dev' to start the app"