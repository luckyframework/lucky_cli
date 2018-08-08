class Api::SignUps::Create < ApiAction
  include Auth::Api::RequireNotSignedIn

  route do
    SignUpForm.create(params) do |form, user|
      if user
        sign_in user
        head Status::OK
      else
        json({errors: form.errors}, Status::BadRequest)
      end
    end
  end
end
