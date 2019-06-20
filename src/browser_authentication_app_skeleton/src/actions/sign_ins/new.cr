class SignIns::New < BrowserAction
  include Auth::RedirectSignedInUsers

  get "/sign_in" do
    render NewPage, operation: SignUserIn.new
  end
end
