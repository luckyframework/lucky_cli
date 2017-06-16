class MainLayout
  include LuckyWeb::Layout

  @page : BasePage

  render do
    h1 "What a wonderful day"
    @page.render_inner
  end
end
