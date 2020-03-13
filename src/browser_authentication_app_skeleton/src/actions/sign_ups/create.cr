class SignUps::Create < BrowserAction
  include Auth::RedirectLoggedInUsers

  route do
    SignUpUser.create(params) do |operation, user|
      if user
        flash.info = "Thanks for signing up"
        log_in(user)
        redirect to: Home::Index
      else
        flash.info = "Couldn't sign you up"
        html NewPage, operation: operation
      end
    end
  end
end
