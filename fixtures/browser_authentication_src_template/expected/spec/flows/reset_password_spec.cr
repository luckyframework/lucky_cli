require "../spec_helper"

# NOTE: LuckyFlow specs are temporarily set to pending as of Lucky v1.4.0
# This is due to race conditions in LuckyFlow.
# Ref: https://github.com/luckyframework/lucky_cli/issues/883
describe "Reset password flow", tags: "flow" do
  pending "works" do
    user = UserFactory.create
    flow = ResetPasswordFlow.new(user)

    flow.request_password_reset
    flow.should_have_sent_reset_email
    flow.reset_password "new-password"
    flow.should_be_signed_in
    flow.sign_out
    flow.sign_in "wrong-password"
    flow.should_have_password_error
    flow.sign_in "new-password"
    flow.should_be_signed_in
  end
end
