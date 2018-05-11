class PasswordResetRequests::New < BrowserAction
  include Auth::RedirectIfSignedIn

  action do
    render NewPage, form: PasswordResetRequestForm.new
  end
end
