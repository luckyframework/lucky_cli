class Api::SignIns::Create < ApiAction
  include Auth::Api::RequireNotSignedIn

  route do
    SignInForm.new(params).submit do |form, user|
      if user
        sign_in user
        head Status::OK
      else
        head Status::Unauthorized
      end
    end
  end
end
