class Shared::LayoutHead < BaseComponent
  needs page_title : String

  def render
    head do
      utf8_charset
      title "My App - #{@page_title}"
      css_link asset("css/app.css")
      js_link asset("js/app.js"), defer: "true"
      csrf_meta_tags if include_csrf_tag?
      responsive_meta_tag

      # Development helper used with the `lucky watch` command.
      # Reloads the browser when files are updated.
      live_reload_connect_tag if LuckyEnv.development?
    end
  end

  # Cross Site Request Forgery protection is
  # enabled by default. This includes a hidden input
  # used in forms when using the `form_for` method.
  #
  # This can be disabled by creating a new `config/forms.cr`
  # file, and setting this to `false`.
  # ```
  # Lucky::FormHelpers.configure do |settings|
  #   settings.include_csrf_tag = false
  # end
  # ```
  private def include_csrf_tag? : Bool
    Lucky::FormHelpers.settings.include_csrf_tag
  end
end
