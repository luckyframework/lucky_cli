ENV["LUCKY_ENV"] = "test"
require "spec"
require "lucky_flow"
require "../src/app"
require "./support/**"

Spec.before_each do
  LuckyRecord::Repo.truncate
end
