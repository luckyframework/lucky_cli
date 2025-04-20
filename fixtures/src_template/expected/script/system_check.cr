require "./helpers/*"

# Use this script to check the system for required tools and process that your app needs.
# A few helper functions are provided to keep the code simple. See the
# script/helpers/function_helpers.cr file for more examples.
#
# A few examples you might use here:
#   * 'lucky db.verify_connection' to test postgres can be connected
#   * Checking that elasticsearch, redis, or postgres is installed and/or booted
#   * Note: Booting additional processes for things like mail, background jobs, etc...
#     should go in your Procfile.dev.


# CUSTOM PRE-BOOT CHECKS
# example:
# if command_not_running "redis-cli", "ping"
#   print_error "Redis is not running."
# end
