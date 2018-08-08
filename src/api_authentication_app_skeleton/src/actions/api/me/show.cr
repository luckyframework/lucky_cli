class Api::Me::Show < ApiAction
  get "/api/me" do
    json Users::ShowSerializer.new(current_user)
  end
end
