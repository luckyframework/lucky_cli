require "../spec_helper"

include WithProjectCleanup
include ShouldRunSuccessfully

describe "Lucky CLI", tags: "end_to_end" do
  describe "building a full browser app without authentication" do
    it "generates the app and runs the included specs" do
      with_project_cleanup do
        should_run_successfully "crystal run src/lucky.cr -- init.custom test-project --no-auth"

        FileUtils.cd "test-project" do
          should_run_successfully "crystal script/setup.cr"
          should_run_successfully "crystal build src/test_project.cr"
          should_run_successfully "lucky gen.action.api Api::Users::Show"
          should_run_successfully "lucky gen.action.browser Users::Show"
          should_run_successfully "lucky gen.migration CreateThings"
          should_run_successfully "lucky gen.model User"
          should_run_successfully "lucky gen.page Users::IndexPage"
          should_run_successfully "lucky gen.component Users::Header"
          should_run_successfully "lucky gen.resource.browser Comment title:String"
          should_run_successfully "lucky gen.task email.monthly_update"
          should_run_successfully "lucky gen.secret_key"
          should_run_successfully "crystal spec"

          {% if !flag?(:windows) %}
            # Due to formatter on Windows checking different line endings, this will report changes to all crystal files
            # We only need to test this on 1 OS to ensure things are good
            should_run_successfully "crystal tool format --check spec src config"
          {% end %}
        end
      end
    end
  end
end
