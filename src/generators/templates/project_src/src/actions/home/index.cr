class Home::Index < BaseAction
  get "/" do
    render name: "Human"
  end
end
