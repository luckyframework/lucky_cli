require "./app"
require "colorize"

server = HTTP::Server.new("127.0.0.1", 8080, [
  HTTP::ErrorHandler.new,
  HTTP::LogHandler.new,
  LuckyWeb::RouteHandler.new,
  HTTP::StaticFileHandler.new("./public", false),
])

puts "Listening on http://127.0.0.1:8080..."

server.listen
