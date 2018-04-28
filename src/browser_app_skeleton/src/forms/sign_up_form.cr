class SignUpForm < User::BaseForm
  # Change password validations in src/forms/mixins/password_validations.cr
  include PasswordValidations

  allow email
  allow_virtual password : String
  allow_virtual password_confirmation : String

  def prepare
    validate_uniqueness_of email
    run_password_validations
    Authentic.save_encrypted password, to: encrypted_password
  end
end
