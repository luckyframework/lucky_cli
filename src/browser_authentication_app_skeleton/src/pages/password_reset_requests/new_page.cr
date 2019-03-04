class PasswordResetRequests::NewPage < AuthLayout
  needs form : PasswordResetRequestForm

  def content
    h1 "Reset your password"
    render_form(@form)
  end

  private def render_form(f)
    form_for PasswordResetRequests::Create do
      mount Shared::Field.new(f.email), &.email_input
      submit "Reset Password", flow_id: "request-password-reset-button"
    end
  end
end
