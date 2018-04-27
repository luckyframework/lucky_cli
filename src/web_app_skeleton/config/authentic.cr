require "./server"

Authentic.configure do
  settings.secret_key = Lucky::Server.settings.secret_key_base
end
