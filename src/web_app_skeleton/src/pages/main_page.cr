require "./base_page"

abstract class MainPage < BasePage
  # You can put assigns here that all pages inheriting from this page need
  #
  # Example:
  #   assign current_user : User

  macro inherited
    layout MainLayout
  end

  def page_title
    "Lucky - change at src/pages/main_page.cr"
  end
end
