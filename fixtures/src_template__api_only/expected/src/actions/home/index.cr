class Home::Index < ApiAction
  get "/" do
    json({hello: "Hello World from Home::Index"})
  end
end
