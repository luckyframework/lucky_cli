require "../../spec_helper"

describe "Home" do
  it "says hello" do
    request = AppRequest.new

    request.get("/api")

    request.response_json.should eq ({"hello" => "Hello World from Home::Index"})
  end
end
