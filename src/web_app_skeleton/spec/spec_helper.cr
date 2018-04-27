ENV["LUCKY_ENV"] = "test"
ENV["PORT"] = "5001"
require "spec"
require "lucky_flow"
require "../src/app"
require "./support/**"

app = App.new

spawn do
  app.listen
end

Spec.before_each do
  LuckyRecord::Repo.truncate
end

at_exit do
  LuckyFlow.shutdown
  app.close
end
