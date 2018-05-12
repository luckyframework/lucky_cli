require "./server"

Lucky::Session::Store.configure do
  settings.key = "upgrade_diffs"
  settings.secret = Lucky::Server.settings.secret_key_base
end
