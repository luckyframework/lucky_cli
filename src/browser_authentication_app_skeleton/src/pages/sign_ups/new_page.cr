class SignUps::NewPage < AuthLayout
  needs form : SignUpForm

  def content
    h1 "Sign Up"
    render_sign_up_form(@form)
  end

  private def render_sign_up_form(f)
    form_for SignUps::Create do
      sign_up_fields(f)
      submit "Sign Up", flow_id: "sign-up-button"
    end
    link "Sign in instead", to: SignIns::New
  end

  private def sign_up_fields(f)
    mount Shared::Field.new(f.email), &.email_input(autofocus: "true")
    mount Shared::Field.new(f.password), &.password_input
    mount Shared::Field.new(f.password_confirmation), &.password_input
  end
end
