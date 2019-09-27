require "random/secure"

class BrowserSrcTemplate < Teeplate::FileTree
  directory "#{__DIR__}/../browser_app_skeleton"
  getter? generate_auth

  def initialize(@generate_auth : Bool)
  end
end
