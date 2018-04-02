require "random/secure"

class BrowserSrcTemplate < Teeplate::FileTree
  directory "#{__DIR__}/../browser_app_skeleton"

  def initialize
  end
end
