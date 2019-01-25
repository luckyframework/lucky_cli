require "spec"
require "file_utils"
require "json"
require "http"
require "../src/lucky_cli"
require "./support/**"

FileUtils.mkdir_p("bin/lucky")

if !setup_precompiled_task.success?
  raise "Failed to setup precompiled task"
end

private def setup_precompiled_task
  Process.run(
    "crystal build spec/support/precompiled_task.cr -o bin/lucky.precompiled_task",
    shell: true,
    output: IO::Memory.new,
    error: STDERR
  )
end
