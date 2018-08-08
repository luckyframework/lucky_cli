require "../../spec_helper"

describe "Me" do
  it "returns current user" do
    request = AppRequest.new
    user = UserBox.create

    request.get "/api/me", as: user
    request.response_json.should eq ({"id" => user.id, "email": user.email})
  end

  it "rejects unauthenticated requests" do
    request = AppRequest.new

    request.get "/api/me"
    request.response.status_code.should eq 401
  end
end
