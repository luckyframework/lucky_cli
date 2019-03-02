class SignIns::New < BrowserAction
  include Auth::RedirectSignedInUsers

  get "/sign_in" do
    render NewPage, form: SignInForm.new
  end
end
