# When testing you can skip normal sign in by using `visit` with the `as` param
#
#     user = UserBox.create
#     flow.visit Me::Show, as: user
#
# The module only works in the 'test' environment.
module Auth::TestBackdoor
  {% if env("LUCKY_ENV") == "test" %}
    macro included
      before test_backdoor
    end

    private def test_backdoor
      if user_id = params.get?(:backdoor_user_id)
        user = UserQuery.find(user_id)
        sign_in user
      end
      continue
    end
  {% end %}
end
