class SignUps::Create < BrowserAction
  include Auth::RedirectIfSignedIn

  action do
    SignUpForm.create(params) do |form, user|
      if user
        flash.info = "Signed up!"
        sign_in(user)
        redirect to: SignUps::New
      else
        flash.info = "Couldn't sign you up"
        render NewPage, form: form
      end
    end
  end
end
