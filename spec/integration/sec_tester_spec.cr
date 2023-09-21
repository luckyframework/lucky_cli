{% skip_file unless env("RUN_HEROKU_SPECS") == "1" %}

require "../spec_helper"

include ShouldRunSuccessfully
include WithProjectCleanup

describe "Apps with SecTester enabled", tags: ["integration", "sec_tester"] do
  it "creates a full app with sec_tester enabled" do
    puts "Web app with SecTester: Running integration spec. This might take awhile...".colorize(:yellow)
    with_project_cleanup do
      should_run_successfully "crystal run src/lucky.cr -- init.custom test-project --with-sec-test"

      FileUtils.cd "test-project" do
        File.read("spec/setup/sec_tester.cr").should contain "LuckySecTester"
        File.read(".github/workflows/ci.yml").should contain "-Dwith_sec_tests"
        File.read("spec/flows/security_spec.cr").should contain "dom_xss"
        should_run_successfully "./script/setup"
        should_run_successfully "crystal spec -Dwith_sec_tests"
      end
    end
  end
end
