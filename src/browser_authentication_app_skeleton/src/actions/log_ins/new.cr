class LogIns::New < BrowserAction
  include Auth::RedirectLoggedInUsers

  get "/log_in" do
    html NewPage, operation: LogInUser.new
  end
end
