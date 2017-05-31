class WebpackerGenerator
  def initialize(@project_name : String)
  end

  def self.run(project_name : String)
    puts "Adding webpacker config and asset directories"
    new(project_name).install
  end

  def install
    FileUtils.cp_r("#{__DIR__}/asset_templates", "#{@project_name}/assets/")
    FileUtils.cp_r("#{__DIR__}/webpacker_templates", "#{@project_name}/config/")
    FileUtils.cd(@project_name)
    # copy_babelrc
    # copy_postcss
    add_yarn_deps
  end

  private def add_yarn_deps
    puts "Installing all JavaScript dependencies"
    run "yarn add webpack webpack-merge js-yaml path-complete-extname " \
        "webpack-manifest-plugin babel-loader@7.x coffee-loader coffee-script " \
        "babel-core babel-preset-env babel-polyfill compression-webpack-plugin rails-erb-loader glob " \
        "extract-text-webpack-plugin node-sass file-loader sass-loader css-loader style-loader " \
        "postcss-loader postcss-cssnext postcss-smart-import resolve-url-loader " \
        "babel-plugin-syntax-dynamic-import babel-plugin-transform-class-properties"

    puts "Installing dev server for live reloading"
    run "yarn add --dev webpack-dev-server"
  end

  private def run(command)
    Process.run command,
      shell: true,
      output: true,
      error: true
  end
end
