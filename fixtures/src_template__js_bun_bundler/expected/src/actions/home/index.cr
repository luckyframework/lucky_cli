class Home::Index < BrowserAction
  get "/" do
    html Lucky::WelcomePage
  end
end
