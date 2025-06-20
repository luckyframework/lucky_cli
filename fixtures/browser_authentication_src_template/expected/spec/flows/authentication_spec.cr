require "../spec_helper"

# NOTE: LuckyFlow specs are temporarily set to pending as of Lucky v1.4.0
# This is due to race conditions in LuckyFlow.
# Ref: https://github.com/luckyframework/lucky_cli/issues/883
describe "Authentication flow", tags: "flow" do
  pending "works" do
    flow = AuthenticationFlow.new("test@example.com")

    flow.sign_up "password"
    flow.should_be_signed_in
    flow.sign_out
    flow.sign_in "wrong-password"
    flow.should_have_password_error
    flow.sign_in "password"
    flow.should_be_signed_in
  end

  # This is to show you how to sign in as a user during tests.
  # Use the `visit` method's `as` option in your tests to sign in as that user.
  #
  # Feel free to delete this once you have other tests using the 'as' option.
  pending "allows sign in through backdoor when testing" do
    user = UserFactory.create
    flow = BaseFlow.new

    flow.visit Me::Show, as: user
    should_be_signed_in(flow)
  end
end

private def should_be_signed_in(flow)
  flow.should have_element("@sign-out-button")
end
