{% skip_file unless flag?(:with_sec_tests) %}
# Run these specs with `crystal spec -Dwith_sec_tests`

require "../spec_helper"

describe "SecTester" do
  it "tests the sign_in API for SQLi, and JWT attacks" do
    scan_with_cleanup do |scanner|
      api_headers = HTTP::Headers{"Content-Type" => "application/json", "Accept" => "application/json"}
      target = scanner.build_target(Api::SignIns::Create, headers: api_headers) do |t|
        t.body = {"user" => {"email" => "aa@aa.com", "password" => "123456789"}}.to_json
      end
      scanner.run_check(
        scan_name: "ref: #{ENV["GITHUB_REF"]?} commit: #{ENV["GITHUB_SHA"]?} run id: #{ENV["GITHUB_RUN_ID"]?}",
        tests: [
          "sqli",                 # Testing for SQL Injection issues (https://docs.brightsec.com/docs/sql-injection)
          "jwt",                  # Testing JWT usage (https://docs.brightsec.com/docs/broken-jwt-authentication)
          "xss",                  # Testing for Cross Site Scripting attacks (https://docs.brightsec.com/docs/reflective-cross-site-scripting-rxss)
          "ssrf",                 # Testing for SSRF (https://docs.brightsec.com/docs/server-side-request-forgery-ssrf)
          "mass_assignment",      # Testing for Mass Assignment issues (https://docs.brightsec.com/docs/mass-assignment)
          "full_path_disclosure", # Testing for full path disclourse on api error (https://docs.brightsec.com/docs/full-path-disclosure)
        ],
        target: target
      )
    end
  end
end

private def scan_with_cleanup(&) : Nil
  scanner = LuckySecTester.new
  yield scanner
ensure
  scanner.try &.cleanup
end
