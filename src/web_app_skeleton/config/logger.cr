require "file_utils"

logger =
  if Lucky::Env.test?
    # Logs to `tmp/test.log` so you can see what's happening without having
    # a bunch of log output in your spec results.
    FileUtils.mkdir_p("tmp")
    Dexter::Logger.new(
      io: File.new("tmp/test.log", mode: "w"),
      level: Logger::Severity::DEBUG,
      log_formatter: Lucky::PrettyLogFormatter
    )
  elsif Lucky::Env.production?
    # This sets the log formatter to JSON so you can parse the logs with
    # services like Logentries or Logstash.
    #
    # If you want logs like in develpoment use `Lucky::PrettyLogFormatter`.
    Dexter::Logger.new(
      io: STDOUT,
      level: Logger::Severity::INFO,
      log_formatter: Dexter::Formatters::JsonLogFormatter
    )
  else
    # For development, log everything to STDOUT with the pretty formatter.
    Dexter::Logger.new(
      io: STDOUT,
      level: Logger::Severity::DEBUG,
      log_formatter: Lucky::PrettyLogFormatter
    )
  end

Lucky.configure do |settings|
  settings.logger = logger
end

Lucky::Action.configure do |settings|
  # By default Lucky only logs when before/after pipes halt by redirecting, or
  # rendering a response.
  #
  # Set 'pipe_log_level' to a 'Logger::Severity' to log whenever any pipe runs.
  #
  # For example:
  #
  #    settings.pipe_log_level = Logger::Severity::DEBUG
  #
  # Full list of log levels: https://crystal-lang.org/api/Logger/Severity.html#enum-members
  settings.pipe_log_level = nil
end

Lucky::LogHandler.configure do |settings|
  # Skip logging static assets in development
  if Lucky::Env.development?
    settings.skip_if = ->(context : HTTP::Server::Context) {
      context.request.method.downcase == "get" &&
      context.request.resource.starts_with?(/\/css\/|\/js\/|\/assets\/|\/favicon\.ico/)
    }
  end
end

Avram.configure do |settings|
  settings.logger = logger
end
