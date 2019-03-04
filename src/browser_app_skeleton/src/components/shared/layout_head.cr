class Shared::LayoutHead < BaseComponent
  needs page_title : String
  needs context : HTTP::Server::Context

  def render
    head do
      utf8_charset
      title "My App - #{@page_title}"
      css_link asset("css/app.css"), data_turbolinks_track: "reload"
      js_link asset("js/app.js"), defer: "true", data_turbolinks_track: "reload"
      csrf_meta_tags
      responsive_meta_tag
    end
  end
end
