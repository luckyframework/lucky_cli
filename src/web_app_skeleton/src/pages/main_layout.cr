abstract class MainLayout
  include LuckyWeb::HTMLPage

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
        inner
      end
    end
  end

  def page_title
    "Welcome to Lucky"
  end

  def errors_for(field : LuckyRecord::AllowedField)
    # Customize the markup and styles to match your application
    unless field.valid?
      div class: "error" do
        text "#{field.name.to_s.capitalize} #{field.errors.join(", ")}"
      end
    end
  end
end
