class SignIns::New < BrowserAction
  include Auth::RedirectSignedInUsers

  get "/sign_in" do
    render NewPage, form: SignUserIn.new
  end
end
