app_server = AppServer.new

spawn do
  app_server.listen
end

at_exit do
  LuckyFlow.shutdown
end
