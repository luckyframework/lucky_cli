class PasswordResetRequests::New < BrowserAction
  include Auth::RedirectSignedInUsers

  route do
    render NewPage, form: RequestPasswordReset.new
  end
end
