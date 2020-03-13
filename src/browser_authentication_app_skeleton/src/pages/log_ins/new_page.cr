class LogIns::NewPage < AuthLayout
  needs operation : LogInUser

  def content
    h1 "Sign In"
    render_log_in_form(@operation)
  end

  private def render_log_in_form(op)
    form_for LogIns::Create do
      log_in_fields(op)
      submit "Sign In", flow_id: "log-out-button"
    end
    link "Reset password", to: PasswordResetRequests::New
    text " | "
    link "Sign up", to: SignUps::New
  end

  private def log_in_fields(op)
    mount Shared::Field.new(op.email, "Email"), &.email_input(autofocus: "true")
    mount Shared::Field.new(op.password, "Password"), &.password_input
  end
end
