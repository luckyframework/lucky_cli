abstract class BasePage
  include LuckyWeb::Page

  macro inherited
    # You can put assigns here that all pages need
    #
    # Example:
    #   assign current_user : User

    layout MainLayout
  end
end
