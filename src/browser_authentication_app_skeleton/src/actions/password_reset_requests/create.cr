class PasswordResetRequests::Create < BrowserAction
  include Auth::RedirectLoggedInUsers

  route do
    RequestPasswordReset.new(params).submit do |operation, user|
      if user
        PasswordResetRequestEmail.new(user).deliver
        flash.success = "You should receive an email on how to reset your password shortly"
        redirect LogIns::New
      else
        html NewPage, operation: operation
      end
    end
  end
end
