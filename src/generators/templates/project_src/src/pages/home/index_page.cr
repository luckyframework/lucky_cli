class Home::IndexPage < BasePage
  assign name : String

  render do
    text "Welcome, #{@name}!"
  end
end
