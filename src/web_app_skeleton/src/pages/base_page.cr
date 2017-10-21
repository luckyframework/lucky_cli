abstract class BasePage
  include LuckyWeb::Page

  # You can put assigns here that all pages need
  #
  # Example:
  #   assign current_user : User

  macro inherited
    layout MainLayout
  end

  def page_title
    "Lucky - change at src/pages/base_page.cr"
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
