require "./base_action"

abstract class ApiAction < BaseAction
  # in src/pipes/only_allow_json.cr
  include OnlyAllowJson
end
