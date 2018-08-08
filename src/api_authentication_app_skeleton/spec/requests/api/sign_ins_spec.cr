require "../../spec_helper"

describe "SignIns" do
  it "signs in valid user" do
    request = AppRequest.new

    user = UserBox.new.create

    request.post("/api/sign_ins", ({
      "sign_in:email"    => user.email,
      "sign_in:password" => "password",
    }))

    request.response.status_code.should eq 200
    request.response.headers["Authorization"].should eq user.generate_token
  end
end
