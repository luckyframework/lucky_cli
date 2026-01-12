require "../spec_helper"

include WithProjectCleanup
include ShouldRunSuccessfully

describe "Lucky CLI", tags: "end_to_end" do
  describe "building a full browser app with authentication and sec tester included" do
    it "generates the app and runs the included specs" do
      with_project_cleanup do
        should_run_successfully "crystal run src/lucky.cr -- init.custom test-project --with-sec-test"

        FileUtils.cd "test-project" do
          should_run_successfully "crystal tool format --check spec src config"
          should_run_successfully "crystal script/setup.cr"
          should_run_successfully "crystal build src/test_project.cr"
          should_run_successfully "crystal spec"
          should_run_successfully "lucky tasks"
        end
      end
    end
  end
end
