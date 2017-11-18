require "./app"

server = HTTP::Server.new("127.0.0.1", 8080, [
  LuckyWeb::HttpMethodOverrideHandler.new,
  LuckyWeb::LogHandler.new,
  LuckyWeb::SessionHandler.new,
  LuckyWeb::Flash::Handler.new,
  LuckyWeb::ErrorHandler.new(action: Errors::Show),
  LuckyWeb::RouteHandler.new,
  LuckyWeb::StaticFileHandler.new("./public", false),
])

puts "Listening on http://127.0.0.1:8080..."

server.listen
