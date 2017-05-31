class AppHome < LuckyWeb::Action
  get "/" do
    render_text "Welcome to Lucky!"
  end
end