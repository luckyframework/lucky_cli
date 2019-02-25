require "file_utils"

logger =
  if Lucky::Env.test?
    # Logs to `tmp/test.log` so you can see what's happening without having
    # a bunch of log output in your specs results.
    FileUtils.mkdir("tmp")
    Lucky::Logger.new(
      io: File.new("tmp/test.log", mode: "w"),
      level: Logger::Severity::DEBUG,
      log_formatter: Lucky::PrettyLogFormatter.new
    )
  elsif Lucky::Env.production?
    # This sets the log formatter to JSON so you can parse the logs with
    # services like Logentries or Logstash.
    #
    # If you want logs like in develpoment use `Lucky::PrettyLogFormatter`.
    Lucky::Logger.new(
      io: STDOUT,
      level: Logger::Severity::INFO,
      log_formatter: Lucky::JsonLogFormatter.new
    )
  else
    # For development, log everything to STDOUT with the pretty formatter
    Lucky::Logger.new(
      io: STDOUT,
      level: Logger::Severity::DEBUG,
      log_formatter: Lucky::PrettyLogFormatter.new
    )
  end

Lucky.configure do |settings|
  settings.logger = logger
end

Lucky::LogHandler.configure do |settings|
  settings.logger = logger
end
