require "random/secure"

class BrowserSrcTemplate < Teeplate::FileTree
  alias Options = LuckyCli::Generators::Web::Options

  delegate generate_auth?, to: @options
  directory "#{__DIR__}/../browser_app_skeleton"

  def initialize(@options : Options)
  end
end
