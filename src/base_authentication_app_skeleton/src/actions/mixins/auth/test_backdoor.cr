# When testing you can skip normal sign in by using `visit` with the `as` param
#
#     user = UserBox.create
#     flow.visit Me::Show, as: user
#
# The module is included in specs automatically: spec/setup/add_test_backdoor.cr
module Auth::TestBackdoor
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
end
