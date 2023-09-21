app_server = AppServer.new

spawn do
  app_server.listen
end

Spec.after_suite do
  app_server.close
end
