class MainLayout
  include LuckyWeb::Page
  include LuckyWeb::Layout

  @page : BasePage

  render do
    html_doctype

    html do
      head do
        title @page.page_title
        css_link asset("app.css")
        js_link asset("app.js")
      end

      body do
        h1 "What a wonderful day"
        @page.render_inner
      end
    end
  end
end
