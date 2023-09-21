# Environments are managed using `LuckyEnv`. By default, development, production
# and test are supported. See
# https://luckyframework.org/guides/getting-started/configuration for details.
#
# The default environment is development unless the environment variable
# LUCKY_ENV is set.
#
# Example:
# ```
# LuckyEnv.environment  # => "development"
# LuckyEnv.development? # => true
# LuckyEnv.production?  # => false
# LuckyEnv.test?        # => false
# ```
#
# New environments can be added using the `LuckyEnv.add_env` macro.
#
# Example:
# ```
# LuckyEnv.add_env :staging
# LuckyEnv.staging? # => false
# ```
#
# To determine whether or not a `LuckyTask` is currently running, you can use
# the `LuckyEnv.task?` predicate.
#
# Example:
# ```
# LuckyEnv.task? # => false
# ```

# Add a staging environment.
# LuckyEnv.add_env :staging
