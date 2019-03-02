class PasswordResetRequests::New < BrowserAction
  include Auth::RedirectSignedInUsers

  route do
    render NewPage, form: PasswordResetRequestForm.new
  end
end
