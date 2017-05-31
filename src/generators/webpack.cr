class LuckyCli::Generators::Webpack
  include LuckyCli::GeneratorHelpers

  def initialize(@project_name : String)
    @project_dir = File.join(@project_name)
    @template_dir = File.join(__DIR__, "templates")
  end

  def self.run(project_name : String)
    puts "Adding webpacker config and asset directories"
    new(project_name).install
  end

  def install
    copy_all_templates from: "assets", to: "assets"
    copy_all_templates from: "webpacker", to: "config"
    # copy_babelrc
    # copy_postcss
    add_yarn_deps
  end

  private def add_yarn_deps
    puts "Installing all JavaScript dependencies"
    run_command(
      "yarn add webpack webpack-merge js-yaml path-complete-extname " \
      "webpack-manifest-plugin babel-loader@7.x coffee-loader coffee-script " \
      "babel-core babel-preset-env babel-polyfill compression-webpack-plugin rails-erb-loader glob " \
      "extract-text-webpack-plugin node-sass file-loader sass-loader css-loader style-loader " \
      "postcss-loader postcss-cssnext postcss-smart-import resolve-url-loader " \
      "babel-plugin-syntax-dynamic-import babel-plugin-transform-class-properties"
    )

    puts "Installing dev server for live reloading"
    run_command "yarn add --dev webpack-dev-server"
  end
end
