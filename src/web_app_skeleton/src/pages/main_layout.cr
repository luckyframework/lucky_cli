abstract class MainLayout
  include LuckyWeb::HTMLPage
  include Shared::FieldErrorsComponent
  include Shared::FlashComponent

  # You can put things here that all pages need
  #
  # Example:
  #   needs current_user : User
  needs flash : LuckyWeb::Flash::Store

  abstract def inner

  render do
    html_doctype

    html lang: "en" do
      head do
        utf8_charset
        title page_title
        css_link asset("css/app.css")
        js_link asset("js/app.js")
      end

      body do
        render_flash
        inner
      end
    end
  end

  def page_title
    "Welcome to Lucky"
  end
end
