require "colorize"
require "ecr"
require "athena-console"
require "nox"
require "lucky_task"
require "./lucky_cli/version"
require "./lucky_cli"
require "./validators/*"
require "./commands/*"
# require "./lucky_cli"

# Create an ACON::Application, passing it the name of your CLI.
# Optionally accepts a second argument representing the version of
# the CLI.
application = ACON::Application.new("lucky", LuckyCli::VERSION)

# Add commands
application.add InitCommand.new
application.add InitCustomCommand.new
application.add DevCommand.new
application.add TaskCommand.new

# Run the application.
# By default this uses STDIN and STDOUT for its input and output.
application.run
