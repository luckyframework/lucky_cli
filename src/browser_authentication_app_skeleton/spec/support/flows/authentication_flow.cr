class AuthenticationFlow < BaseFlow
  private getter email

  def initialize(@email : String)
  end

  def sign_up(password)
    visit SignUps::New
    fill_form SignUpUser,
      email: email,
      password: password,
      password_confirmation: password
    click "@sign-up-button"
  end

  def sign_out
    visit Me::Show
    log_out_button.click
  end

  def log_in(password)
    visit LogIns::New
    fill_form LogInUser,
      email: email,
      password: password
    click "@log-out-button"
  end

  def should_be_logged_in
    log_out_button.should be_on_page
  end

  def should_have_password_error
    el("body", text: "Password is wrong").should be_on_page
  end

  private def log_out_button
    el("@log-out-button")
  end
end
