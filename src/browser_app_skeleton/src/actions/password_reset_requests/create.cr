class PasswordResetRequests::Create < BrowserAction
  include Auth::RedirectIfSignedIn

  action do
    PasswordResetRequestForm.new(params).submit do |form, user|
      if user
        PasswordResetRequestEmail.new(user).deliver
        flash.success = "Your password has been reset. Please check your email"
        redirect SignIns::New
      else
        render NewPage, form: form
      end
    end
  end
end
