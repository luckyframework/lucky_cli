{% skip_file unless flag?(:with_sec_tests) %}
# Run these specs with `crystal spec -Dwith_sec_tests`

require "../spec_helper"

describe "SecTester" do
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
