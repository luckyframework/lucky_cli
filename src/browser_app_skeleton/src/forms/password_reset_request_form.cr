require "./authentic/base_request_password_reset_form"

class PasswordResetRequestForm < LuckyRecord::VirtualForm
  include Authentic::BasePasswordResetRequestForm

  allow_virtual email : String

  def validate_password_request(user : User?)
    validate_required email
    if user.nil?
      email.add_error "is not in our system"
    end
  end

  def when_valid(user : User)
    Authentic.request_password_reset(user)
  end
end
