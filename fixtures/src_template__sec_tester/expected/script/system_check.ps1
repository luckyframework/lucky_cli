.\script\helpers\text_helpers.ps1
.\script\helpers\function_helpers.ps1

# Use this script to check the system for required tools and process that your app needs.
# A few helper functions are provided to make writing bash a little easier. See the 
# script/helpers/function_helpers file for more examples.
#
# A few examples you might use here:
#   * 'lucky db.verify_connection' to test postgres can be connected
#   * Checking that elasticsearch, redis, or postgres is installed and/or booted
#   * Note: Booting additional processes for things like mail, background jobs, etc...
#     should go in your Procfile.dev.


if (CommandNotFound "yarn") {
  PrintError "Yarn is not installed\n  See https://yarnpkg.com/lang/en/docs/install/ for install instructions."
}


if (CommandNotFound "createdb") {
  PrintError "Please install the postgres CLI tools, then try again.\nSee https://www.postgresql.org/docs/current/tutorial-install.html for install instructions."
}

## CUSTOM PRE-BOOT CHECKS ##
# example:
# if (CommandNotFound "redis-cli ping") {
#   PrintError "Redis is not running."
# }


