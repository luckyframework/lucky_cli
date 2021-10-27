# This file may be used for custom Application
# configurations. This file will be loaded before
# other config files.
#
# Read more:
#   https://luckyframework.org/guides/getting-started/configuration#configuring-your-own-code

# Use this template as an example for configuration:
#
# ```
# module Application
#   Habitat.create do
#     setting support_email : String
#     setting lock_with_basic_auth : Bool
#   end
# end
#
# Application.configure do |settings|
#   settings.support_email = "support@myapp.io"
#   settings.lock_with_basic_auth = LuckEnv.staging?
# end
# ```