class LogIns::Create < BrowserAction
  include Auth::RedirectLoggedInUsers

  route do
    LogInUser.new(params).submit do |operation, authenticated_user|
      if authenticated_user
        log_in(authenticated_user)
        flash.success = "You're now logged in"
        Authentic.redirect_to_originally_requested_path(self, fallback: Home::Index)
      else
        flash.failure = "Log in failed"
        html NewPage, operation: operation
      end
    end
  end
end
