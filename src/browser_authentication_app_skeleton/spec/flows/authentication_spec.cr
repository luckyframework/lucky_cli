require "../spec_helper"

describe "Authentication flow" do
  it "works" do
    flow = AuthenticationFlow.new("test@example.com")

    flow.sign_up "password"
    flow.should_be_logged_in
    flow.sign_out
    flow.log_in "wrong-password"
    flow.should_have_password_error
    flow.log_in "password"
    flow.should_be_logged_in
  end

  # This is to show you how to log in as a user during tests.
  # Use the `visit` method's `as` option in your tests to log in as that user.
  #
  # Feel free to delete this once you have other tests using the 'as' option.
  it "allows log in through backdoor when testing" do
    user = UserBox.create
    flow = BaseFlow.new

    flow.visit Me::Show, as: user
    should_be_logged_in(flow)
  end
end

private def should_be_logged_in(flow)
  flow.el("@log-out-button").should be_on_page
end
