require "lucky_sec_tester"

# Signup for a `NEXTPLOT_TOKEN` at
# [NeuraLegion](https://app.neuralegion.com/signup)
# Read more about the SecTester on https://github.com/luckyframework/lucky_sec_tester
LuckySecTester.configure do |setting|
  setting.nexploit_token = ENV["NEXPLOIT_TOKEN"]
end
