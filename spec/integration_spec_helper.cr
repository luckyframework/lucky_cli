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

def fixtures_cat_gif_path
  Path["#{__DIR__}/../fixtures/cat.gif"]
end

def shards_override_path
  Path["#{__DIR__}/../shard.override.yml"]
end
