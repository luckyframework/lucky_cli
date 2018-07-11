abstract class MainLayout
  # Edit shared layout code in src/components/shared/layout.cr
  # Shared::Layout is used to create new layouts with shared code
  include Shared::Layout

  def render
    html_doctype

    html lang: "en" do
      shared_layout_head

      body do
        render_flash
        content
      end
    end
  end
end
