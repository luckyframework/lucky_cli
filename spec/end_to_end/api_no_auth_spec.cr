require "../spec_helper"

include WithProjectCleanup
include ShouldRunSuccessfully

describe "Lucky CLI", tags: "end_to_end" do
  describe "building an API app without authentication" do
    it "generates the app and runs the included specs" do
      with_project_cleanup do
        should_run_successfully "crystal run src/lucky.cr -- init.custom test-project --api --no-auth"

        FileUtils.cd "test-project" do
          {% if !flag?(:windows) %}
            # Due to formatter on Windows checking different line endings, this will report changes to all crystal files
            # We only need to test this on 1 OS to ensure things are good
            should_run_successfully "crystal tool format --check spec src config"
          {% end %}
          should_run_successfully "crystal script/setup.cr"
          should_run_successfully "crystal build src/test_project.cr"
          should_run_successfully "crystal spec"
          should_run_successfully "lucky tasks"
        end
      end
    end
  end
end
