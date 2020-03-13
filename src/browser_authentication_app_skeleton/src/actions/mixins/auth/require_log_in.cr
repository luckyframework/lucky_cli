module Auth::RequireLogIn
  macro included
    before require_log_in
  end

  private def require_log_in
    if current_user?
      continue
    else
      Authentic.remember_requested_path(self)
      flash.info = "Please log in first"
      redirect to: LogIns::New
    end
  end

  # Tells the compiler that the current_user is not nil since we have checked
  # that the user is logged in
  private def current_user : User
    current_user?.not_nil!
  end
end
