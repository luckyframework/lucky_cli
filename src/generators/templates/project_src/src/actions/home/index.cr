class Home::Index < BaseAction
  get "/" do
    render_text "Welcome to Lucky!"
  end
end
