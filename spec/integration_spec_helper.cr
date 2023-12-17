require "spec"
require "file_utils"
require "json"
require "http"
require "./support/**"
require "../src/lucky_cli"

def run_lucky(cmd, **kwargs)
  Process.run("lucky #{cmd}", **kwargs)
end

def fixtures_tasks_path
  Path["#{__DIR__}/../fixtures/tasks.cr"]
end
