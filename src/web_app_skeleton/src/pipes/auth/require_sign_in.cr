module Auth::RequireSignIn
  macro included
    before require_sign_in
  end

  private def require_sign_in
    if signed_in?
      continue
    else
      Authentic.remember_requested_path(self)
      flash.info = "Please sign in first"
      redirect to: SignIns::New
    end
  end

  # Tells the compiler that the current_user is not nil since we have check
  # that the user is signed in
  private def current_user : User
    current_user?.not_nil!
  end
end
