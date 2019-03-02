class SignUps::New < BrowserAction
  include Auth::RedirectSignedInUsers

  get "/sign_up" do
    render NewPage, form: SignUpForm.new
  end
end
