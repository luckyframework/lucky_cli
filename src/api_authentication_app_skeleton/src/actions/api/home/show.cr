class Api::Home::Show < ApiAction
  include Auth::SkipRequireSignIn

  get "/api" do
    json ({"hello" => "Hello World from Home::Index"})
  end
end
