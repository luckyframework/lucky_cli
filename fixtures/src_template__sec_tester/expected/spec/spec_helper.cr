ENV["LUCKY_ENV"] = "test"
ENV["DEV_PORT"] = "5001"
require "spec"
require "lucky_flow"
require "lucky_flow/ext/lucky"
require "lucky_flow/ext/avram"
require "../src/app"
require "./support/flows/base_flow"
require "./support/**"
require "../db/migrations/**"

# Add/modify files in spec/setup to start/configure programs or run hooks
#
# By default there are scripts for setting up and cleaning the database,
# configuring LuckyFlow, starting the app server, etc.
require "./setup/**"

include Carbon::Expectations
include Lucky::RequestExpectations
# NOTE: LuckyFlow specs are temporarily set to pending as of Lucky v1.4.0
# This is due to race conditions in LuckyFlow.
# Ref: https://github.com/luckyframework/lucky_cli/issues/883
include LuckyFlow::Expectations

Avram::Migrator::Runner.new.ensure_migrated!
Avram::SchemaEnforcer.ensure_correct_column_mappings!
Habitat.raise_if_missing_settings!
