abstract class BasePage
  include LuckyWeb::Page

  macro inherited
    # You can put assigns here that all pages need
    #
    # Example:
    #   assign current_user : User

    layout MainLayout
  end

  def page_title
    "Lucky - change at src/pages/base_page.cr"
  end
end
