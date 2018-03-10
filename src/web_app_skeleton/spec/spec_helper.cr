ENV["LUCKY_ENV"] = "test"
require "spec"
require "../src/app"
require "./support/**"

Spec.before_each do
  LuckyRecord::Repo.truncate
end
