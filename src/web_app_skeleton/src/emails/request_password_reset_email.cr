class RequestPasswordResetEmail < BaseEmail
  def initialize(@user : User, @token : String)
  end

  to @user
  from "myapp@support.com" # or set a default in src/emails/base_email.cr
  subject "Reset your password"
  templates html, text
end
