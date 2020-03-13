require "../spec_helper"

describe "Reset password flow" do
  it "works" do
    user = UserBox.create
    flow = ResetPasswordFlow.new(user)

    flow.request_password_reset
    flow.should_have_sent_reset_email
    flow.reset_password "new-password"
    flow.should_be_logged_in
    flow.sign_out
    flow.log_in "wrong-password"
    flow.should_have_password_error
    flow.log_in "new-password"
    flow.should_be_logged_in
  end
end
