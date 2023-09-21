{% skip_file unless flag?(:with_sec_tests) %}
# Run these specs with `crystal spec -Dwith_sec_tests`

require "../spec_helper"

describe "SecTester" do
end

private def scan_with_cleanup(&) : Nil
  scanner = LuckySecTester.new
  yield scanner
ensure
  scanner.try &.cleanup
end
