require "../../spec_helper"

describe "SignUps" do
  it "creates user on sign up" do
    request = AppRequest.new

    request.post("/api/sign_ups", ({
      "sign_up:email"                 => "test@email.com",
      "sign_up:password"              => "password",
      "sign_up:password_confirmation" => "password",
    }))
    new_user = UserQuery.new.email("test@email.com").first

    new_user.should_not be_nil
    request.response.status_code.should eq 200
    request.response.headers["Authorization"].should eq new_user.generate_token
  end
end
