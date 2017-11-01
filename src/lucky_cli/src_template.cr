class SrcTemplate < Teeplate::FileTree
  directory "#{__DIR__}/../web_app_skeleton"
  getter project_name
  getter crystal_project_name : String

  def initialize(@project_name : String)
    @crystal_project_name = @project_name.gsub("-", "_")
  end
end
