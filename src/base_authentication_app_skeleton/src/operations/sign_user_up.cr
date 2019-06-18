class SignUserUp < User::SaveOperation
  # Change password validations in src/operations/mixins/password_validations.cr
  include PasswordValidations

  permit_columns email
  virtual password : String
  virtual password_confirmation : String

  def prepare
    validate_uniqueness_of email
    run_password_validations
    Authentic.copy_and_encrypt password, to: encrypted_password
  end
end
