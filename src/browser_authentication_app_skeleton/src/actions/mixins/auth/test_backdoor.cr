module Auth::TestBackdoor
  macro included
    before test_backdoor
  end

  private def test_backdoor
    if Lucky::Env.test? && (user_id = params.get?(:backdoor_user_id))
      user = UserQuery.find(user_id)
      log_in user
    end
    continue
  end
end
