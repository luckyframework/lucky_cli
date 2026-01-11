require "spec"
require "file_utils"
require "json"
require "http"
require "lucky_template/spec"
require "./support/**"
require "../src/lucky_cli"

include LuckyTemplate::Spec

# Executes a new `lucky` process
#
# NOTE: will mark the spec as pending if lucky command is not found
def run_lucky(**kwargs)
  unless Process.find_executable("lucky")
    pending!("lucky command not found")
  end
  Process.run("lucky", **kwargs)
end
