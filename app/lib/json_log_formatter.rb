require "active_support/tagged_logging"
require "json"
require "time"

class JsonLogFormatter < ::Logger::Formatter
  include ActiveSupport::TaggedLogging::Formatter

  def initialize(environment: Rails.env)
    super()
    @environment = environment.to_s
  end

  def call(severity, timestamp, _progname, message)
    payload = message.is_a?(Hash) ? message : { message: }
    context = payload[:context] || payload["context"]
    context = {} unless context.is_a?(Hash)
    context = context.merge(tags: current_tags.dup) if current_tags.any?
    text = payload[:message] || payload["message"]

    {
      timestamp: timestamp.getutc.iso8601(3),
      level: severity,
      service: "check-client-qualifies",
      environment: @environment,
      correlationId: payload[:correlationId] || payload["correlationId"] || current_tags.first,
      message: text.is_a?(Exception) ? "#{text.message} (#{text.class})\n#{Array(text.backtrace).join("\n")}" : text.to_s,
      context:,
    }.to_json << "\n"
  end
end
