require "random/secure"

class SrcTemplate < Teeplate::FileTree
  alias Options = LuckyCli::Generators::Web::Options

  directory "#{__DIR__}/../web_app_skeleton"
  getter project_name
  delegate api_only?, generate_auth?, to: @options
  getter crystal_project_name : String

  def initialize(@project_name : String, @options : Options)
    @crystal_project_name = @project_name.gsub("-", "_")
  end

  def proxied_through_browsersync?
    browser?
  end

  private def browser?
    !api_only?
  end

  def secret_key_base
    Random::Secure.base64(32)
  end
end
