class PasswordResetRequests::Create < BrowserAction
  include Auth::RedirectIfSignedIn

  action do
    PasswordResetRequestForm.submit(params) do |form|
      if form.valid?
        flash.success = "Your password has been reset. Please check your email"
        redirect to: SignIns::New
      else
        render NewPage, form: form
      end
    end
  end
end
