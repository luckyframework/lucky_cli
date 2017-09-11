class Home::Index < BaseAction
  get "/" do
    render LuckyWeb::WelcomePage
  end
end
