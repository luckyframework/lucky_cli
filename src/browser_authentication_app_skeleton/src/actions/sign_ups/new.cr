class SignUps::New < BrowserAction
  include Auth::RedirectLoggedInUsers

  get "/sign_up" do
    html NewPage, operation: SignUpUser.new
  end
end
