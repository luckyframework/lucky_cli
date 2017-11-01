class Home::Index < BrowserAction
  get "/" do
    render LuckyWeb::WelcomePage
  end
end
