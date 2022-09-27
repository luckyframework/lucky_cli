class Shared::LayoutHead < BaseComponent
  needs page_title : String

  def render
    head do
      utf8_charset
      title "My App - #{@page_title}"
      css_link asset("css/app.css")
      js_link asset("js/app.js"), defer: "true"
      csrf_meta_tags
      responsive_meta_tag

      # Used only in development when running `lucky watch`.
      # Will reload browser whenever files change.
      # See [docs]()
      live_reload_connect_tag
    end
  end
end
