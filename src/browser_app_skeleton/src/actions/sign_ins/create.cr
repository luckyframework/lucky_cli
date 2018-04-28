class SignIns::Create < BrowserAction
  include Auth::RedirectIfSignedIn

  action do
    SignInForm.submit(params) do |form, authenticated_user|
      if authenticated_user
        sign_in(authenticated_user)
        flash.success = "Sign in worked"
        Authentic.redirect_to_originally_requested_path(self, fallback: Users::Index)
      else
        flash.danger = "Sign in failed"
        render NewPage, form: form
      end
    end
  end
end
