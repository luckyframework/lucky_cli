class LuckyCli::Generators::AssetCompiler
  include LuckyCli::GeneratorHelpers

  def initialize(@project_name : String)
    @project_dir = File.join(@project_name)
    @template_dir = File.join(__DIR__, "templates")
  end

  def self.run(project_name : String)
    puts "Adding brunch config and static asset directories"
    new(project_name).install
  end

  def install
    copy_all_templates from: "static", to: "static"
    copy_all_templates from: "public", to: "public"
    copy_template from: "root/.babelrc", to: ""
    copy_template from: "root/brunch-config.js", to: ""
    copy_template from: "root/.postcssrc.yml", to: ""
    copy_template from: "root/bs-config.js", to: ""
    add_yarn_deps
  end

  private def add_yarn_deps
    puts "Installing all JavaScript dependencies"
    run_command(
      "yarn add #{yarn_packages}"
    )
  end

  private def yarn_packages
    %w[
      jquery
      normalize.css
      path-complete-extname
      postcss-sass-color-functions
      rails-ujs
      turbolinks
      babel-brunch
      babel-plugin-transform-class-properties
      babel-preset-env
      browser-sync
      brunch
      fingerprinter-brunch
      glob
      lost
      postcss-brunch
      postcss-cssnext
      precss
    ].join(" ")
  end
end
