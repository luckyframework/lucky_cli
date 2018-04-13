require "random/secure"

class SrcTemplate < Teeplate::FileTree
  directory "#{__DIR__}/../web_app_skeleton"
  getter project_name
  getter? api_only
  getter crystal_project_name : String

  def initialize(@project_name : String, @api_only = false)
    @crystal_project_name = @project_name.gsub("-", "_")
  end

  private def browser?
    !api_only?
  end

  def secret_key_base
    Random::Secure.base64(32)
  end
end
