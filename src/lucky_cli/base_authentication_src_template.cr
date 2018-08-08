class BaseAuthenticationSrcTemplate < Teeplate::FileTree
  alias Options = LuckyCli::Generators::Web::Options

  delegate api_only?, to: @options
  directory "#{__DIR__}/../base_authentication_app_skeleton"

  def initialize(@options : Options)
  end
end
