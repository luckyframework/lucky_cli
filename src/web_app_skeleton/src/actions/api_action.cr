require "./base_action"

abstract class ApiAction < BaseAction
  include OnlyAllowJsonPipe
end
