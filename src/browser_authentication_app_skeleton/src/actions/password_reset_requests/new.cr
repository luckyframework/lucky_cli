class PasswordResetRequests::New < BrowserAction
  include Auth::RedirectLoggedInUsers

  route do
    html NewPage, operation: RequestPasswordReset.new
  end
end
