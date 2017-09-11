class MainLayout
  include LuckyWeb::Page
  include LuckyWeb::Layout

  @page : BasePage

  render do
    html_doctype

    html do
      head do
        utf8_charset
        title @page.page_title
        css_link asset("css/app.css")
        js_link asset("js/app.js")
      end

      body do
        @page.render_inner
      end
    end
  end
end
