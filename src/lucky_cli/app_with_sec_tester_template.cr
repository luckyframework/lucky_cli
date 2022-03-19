class AppWithSecTesterTemplate < Teeplate::FileTree
  directory "#{__DIR__}/../app_with_sec_tester"

  getter? generate_auth, browser

  def initialize(@generate_auth : Bool, @browser : Bool)
  end
end
