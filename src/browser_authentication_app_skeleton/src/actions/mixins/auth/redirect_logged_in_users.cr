module Auth::RedirectLoggedInUsers
  macro included
    include Auth::AllowGuests
    before redirect_logged_in_users
  end

  private def redirect_logged_in_users
    if current_user?
      flash.success = "You are already logged in"
      redirect to: Home::Index
    else
      continue
    end
  end

  # current_user returns nil because logged in users are redirected.
  def current_user
  end
end
