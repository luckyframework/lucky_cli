module Auth::Api::RequireNotSignedIn
  macro included
    include Auth::SkipRequireSignIn
    before require_not_signed_in
  end

  private def require_not_signed_in
    if current_user?
      json({message: "You are already signed in."}, 200)
    else
      continue
    end
  end

  # current_user returns nil so that it won't accidentally be used
  def current_user
  end
end
