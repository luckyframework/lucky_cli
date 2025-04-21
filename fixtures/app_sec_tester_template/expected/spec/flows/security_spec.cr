{% skip_file unless flag?(:with_sec_tests) %}
# Run these specs with `crystal spec -Dwith_sec_tests`

require "../spec_helper"

describe "SecTester" do
  it "tests the sign_in" do
    scanner = LuckySecTester.new
    target = scanner.build_target(SignIns::New)
    scanner.run_check(
      scan_name: "ref: #{ENV["GITHUB_REF"]?} commit: #{ENV["GITHUB_SHA"]?} run id: #{ENV["GITHUB_RUN_ID"]?}",
      tests: [
        "xss",               # Testing for XSS Injection issues (https://docs.brightsec.com/docs/reflective-cross-site-scripting-rxss)
        "brute_force_login", # Testing for Brute Force on the Login (https://docs.brightsec.com/docs/brute-force-login)
      ],
      target: target
    )
  end

  it "tests the sign_in action with params" do
    scanner = LuckySecTester.new
    target = scanner.build_target(SignIns::Create) do |request|
      request.body = "user%3Aemail=test%40test.com&user%3Apassword=1234"
    end
    scanner.run_check(
      scan_name: "ref: #{ENV["GITHUB_REF"]?} commit: #{ENV["GITHUB_SHA"]?} run id: #{ENV["GITHUB_RUN_ID"]?}",
      tests: [
        "sqli",            # Testing for SQL Injection issues (https://docs.brightsec.com/docs/sql-injection)
        "xss",             # Testing for XSS Injection issues (https://docs.brightsec.com/docs/reflective-cross-site-scripting-rxss)
        "mass_assignment", # Testing for Mass Assignment (https://docs.brightsec.com/docs/mass-assignment)
      ],
      target: target
    )
  end

  it "tests the sign_up action" do
    scanner = LuckySecTester.new
    target = scanner.build_target(SignUps::Create) do |request|
      request.body = "user%3Aemail=aa%40aa.com&user%3Apassword=123456789&user%3Apassword_confirmation=123456789"
    end
    scanner.run_check(
      scan_name: "ref: #{ENV["GITHUB_REF"]?} commit: #{ENV["GITHUB_SHA"]?} run id: #{ENV["GITHUB_RUN_ID"]?}",
      tests: [
        "sqli",                 # Testing for SQL Injection issues (https://docs.brightsec.com/docs/sql-injection)
        "xss",                  # Testing for XSS Injection issues (https://docs.brightsec.com/docs/reflective-cross-site-scripting-rxss)
        "mass_assignment",      # Testing for Mass Assignment issues (https://docs.brightsec.com/docs/mass-assignment)
        "full_path_disclosure", # Testing for full path disclourse on api error (https://docs.brightsec.com/docs/full-path-disclosure)
      ],
      target: target
    )
  end
  it "tests the home page general infra issues" do
    scanner = LuckySecTester.new
    target = scanner.build_target(Home::Index)
    scanner.run_check(
      scan_name: "ref: #{ENV["GITHUB_REF"]?} commit: #{ENV["GITHUB_SHA"]?} run id: #{ENV["GITHUB_RUN_ID"]?}",
      severity_threshold: SecTester::Severity::Medium,
      tests: [
        "header_security", # Testing for header security issues (https://docs.brightsec.com/docs/misconfigured-security-headers)
        "cookie_security", # Testing for Cookie Security issues (https://docs.brightsec.com/docs/sensitive-cookie-in-https-session-without-secure-attribute)
        "proto_pollution", # Testing for proto pollution based vulnerabilities (https://docs.brightsec.com/docs/prototype-pollution)
        "open_buckets",    # Testing for open buckets (https://docs.brightsec.com/docs/open-bucket)
      ],
      target: target
    )
  end

  it "tests app.js for 3rd party issues" do
    scanner = LuckySecTester.new
    target = SecTester::Target.new(Lucky::RouteHelper.settings.base_uri + Lucky::AssetHelpers.asset("js/app.js"))
    scanner.run_check(
      scan_name: "ref: #{ENV["GITHUB_REF"]?} commit: #{ENV["GITHUB_SHA"]?} run id: #{ENV["GITHUB_RUN_ID"]?}",
      tests: [
        "retire_js", # Testing for 3rd party issues (https://docs.brightsec.com/docs/javascript-component-with-known-vulnerabilities)
        "cve_test",  # Testing for known CVEs (https://docs.brightsec.com/docs/cves)
      ],
      target: target
    )
  end
end
