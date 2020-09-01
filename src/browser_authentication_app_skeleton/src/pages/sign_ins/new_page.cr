class SignIns::NewPage < AuthLayout
  needs operation : SignInUser

  def content
    h1 "Sign In"
    render_sign_in_form(@operation)
  end

  private def render_sign_in_form(op)
    form_for SignIns::Create do
      sign_in_fields(op)
      submit "Sign In", flow_id: "sign-in-button"
    end
    link "Reset password", to: PasswordResetRequests::New
    text " | "
    link "Sign up", to: SignUps::New
  end

  private def sign_in_fields(op)
    mount Shared::Field, attribute: op.email, label_text: "Email", &.email_input(autofocus: "true")
    mount Shared::Field, attribute: op.password, label_text: "Password", &.password_input
  end
end
