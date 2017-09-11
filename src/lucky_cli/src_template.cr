class SrcTemplate < Teeplate::FileTree
  directory "#{__DIR__}/../web_app_skeleton"
  getter project_name

  def initialize(@project_name : String)
  end
end
