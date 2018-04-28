require "./authentic/base_sign_in_form"

class SignInForm < LuckyRecord::VirtualForm
  include Authentic::BaseSignInForm

  allow_virtual email : String
  allow_virtual password : String

  # This method is called to allow you to determine if a user can sign in.
  # By default it validates that the user exists and the password is correct.
  #
  # If desired, you can add additional checks in this method, e.g.
  #
  #    if user.locked?
  #      email.add_error "is locked out"
  #    end
  private def validate_allowed_to_sign_in(user : User)
    unless Authentic.correct_password?(user, password.value.to_s)
      password.add_error "is wrong"
    end
  end

  # Called when the user is not found (Nil)
  private def validate_allowed_to_sign_in(user_not_found : Nil)
    email.add_error "is not in our system"
  end
end
