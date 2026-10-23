require "spec_helper"
require "active_support"
require "active_support/tagged_logging"
require "json"
require "open3"
require "stringio"
require "tmpdir"
require_relative "../../app/lib/json_log_formatter"

RSpec.describe JsonLogFormatter, ccq_mode: :embedded do
  subject(:formatter) { described_class.new(environment: "production") }

  let(:output) { StringIO.new }
  let(:logger) do
    base_logger = ActiveSupport::Logger.new(output)
    base_logger.formatter = formatter
    ActiveSupport::TaggedLogging.new(base_logger)
  end

  it "emits the standard envelope with a UTC timestamp" do
    timestamp = Time.new(2026, 10, 20, 12, 30, 0, "+01:00")

    entry = JSON.parse(formatter.call("WARN", timestamp, nil, "Host unavailable"))

    expect(entry).to eq(
      "timestamp" => "2026-10-20T11:30:00.000Z",
      "level" => "WARN",
      "service" => "check-client-qualifies",
      "environment" => "production",
      "correlationId" => nil,
      "message" => "Host unavailable",
      "context" => {},
    )
  end

  it "preserves nested structured context without modifying the supplied hash" do
    context = { event: "embedded.example", statusCode: 403, details: { retry: false, attempts: [1, 2] } }.freeze
    payload = { message: "Example outcome", correlationId: "explicit-request-id", context: }.freeze

    logger.info(payload)
    entry = JSON.parse(output.string)

    expect(entry["message"]).to eq("Example outcome")
    expect(entry["correlationId"]).to eq("explicit-request-id")
    expect(entry["context"]).to eq(JSON.parse(context.to_json))
  end

  it "supports structured hashes with string keys" do
    logger.info("message" => "Example outcome", "correlationId" => "request-id", "context" => { "statusCode" => 401 })

    expect(JSON.parse(output.string)).to include(
      "message" => "Example outcome",
      "correlationId" => "request-id",
      "context" => { "statusCode" => 401 },
    )
  end

  it "encodes framework strings containing quotes and newlines on one physical line" do
    message = "Processing \"embedded\" request\nCompleted 200 OK"

    logger.info(message)

    expect(output.string.lines.size).to eq(1)
    expect(output.string).to end_with("\n")
    expect(JSON.parse(output.string)).to include("message" => message, "context" => {})
  end

  it "preserves an exception and its backtrace on one physical line" do
    error = RuntimeError.new("Unexpected \"failure\"\nMore detail")
    error.set_backtrace(["example.rb:12:in 'perform'", "example.rb:20:in 'call'"])

    logger.error(error)

    expect(output.string.lines.size).to eq(1)
    expect(JSON.parse(output.string)).to include("level" => "ERROR")
    expect(JSON.parse(output.string)["message"]).to include(error.message, "RuntimeError", *error.backtrace)
  end

  it "uses the native request tag without converting the payload into text" do
    logger.tagged("native-request-id", "resource_id:example-case") do
      logger.info(message: "Example outcome", context: { caseId: "example-case" })
    end

    expect(JSON.parse(output.string)).to include(
      "correlationId" => "native-request-id",
      "message" => "Example outcome",
      "context" => { "caseId" => "example-case", "tags" => ["native-request-id", "resource_id:example-case"] },
    )
  end

  it "prefers an explicit correlation ID over the native tag" do
    logger.tagged("native-request-id") do
      logger.info(message: "Example outcome", correlationId: "explicit-request-id", context: {})
    end

    expect(JSON.parse(output.string)["correlationId"]).to eq("explicit-request-id")
  end

  it "does not infer tags from bracketed framework text" do
    logger.info("[not-a-request-id] Framework message")

    expect(JSON.parse(output.string)).to include("correlationId" => nil, "context" => {})
  end

  it "does not leak correlation or case context between sequential request scopes" do
    logger.tagged("first-request", "resource_id:first-case") do
      logger.info(message: "First outcome", context: { caseId: "first-case" })
    end
    logger.tagged("second-request") { logger.info("Second outcome") }
    logger.info("Outside a request")

    entries = output.string.lines.map { |line| JSON.parse(line) }

    expect(entries.map { |entry| entry["correlationId"] }).to eq(["first-request", "second-request", nil])
    expect(entries[1]["context"]).to eq("tags" => %w[second-request])
    expect(entries[2]["context"]).to eq({})
  end

  it "always emits a context object when structured context is missing or invalid" do
    logger.info(message: "Missing context")
    logger.info(message: "Invalid context", context: "not-an-object")

    expect(output.string.lines.map { |line| JSON.parse(line)["context"] }).to eq([{}, {}])
  end

  it "handles ordinary non-string messages without inspecting them" do
    message = double(to_s: "Ordinary message")
    expect(message).not_to receive(:inspect)

    logger.info(message)

    expect(JSON.parse(output.string)["message"]).to eq("Ordinary message")
  end

  describe "Rails boot activation" do
    let(:boot_script) do
      <<~RUBY
        require_relative "config/application"
        Rails.application.config.paths["log"] = ENV.fetch("LOGGING_SMOKE_PATH")
        require_relative "config/environment"
        Rails.logger.tagged("smoke-request-id") do
          Rails.logger.info(message: "JSON logging smoke probe", context: { statusCode: 200 })
          Rails.logger.debug("DEBUG logging smoke probe")
        end
        Rails.logger.flush
        puts JSON.generate(loggingProbe: true, formatter: Rails.application.config.log_formatter.class.name,
                           level: Rails.logger.level, environment: Rails.env.to_s)
      RUBY
    end

    def boot_logging(mode:, environment:, to_stdout: true)
      Dir.mktmpdir("ccq-logging-smoke") do |directory|
        log_path = File.join(directory, "rails.log")
        variables = {
          "CCQ_MODE" => mode,
          "RAILS_ENV" => environment,
          "RACK_ENV" => environment,
          "RAILS_LOG_TO_STDOUT" => to_stdout ? "true" : nil,
          "SECRET_KEY_BASE" => "logging-smoke-test-" * 8,
          "LOGGING_SMOKE_PATH" => log_path,
        }
        stdout, stderr, process_status = Open3.capture3(variables, RbConfig.ruby, "-e", boot_script, chdir: File.expand_path("../..", __dir__))
        expect(process_status).to be_success, "Rails boot failed:\n#{stderr}\n#{stdout}"

        logs = to_stdout ? stdout : File.read(log_path)
        configuration = stdout.lines.find { |line| line.start_with?('{"loggingProbe":') }
        {
          configuration: JSON.parse(configuration),
          entry: logs.lines.find { |line| line.include?("JSON logging smoke probe") },
          logs:,
        }
      end
    end

    [true, false].each do |to_stdout|
      it "emits embedded production JSON through the #{to_stdout ? 'stdout' : 'file'} logger" do
        result = boot_logging(mode: "embedded", environment: "production", to_stdout:)

        expect(result[:configuration]).to include("formatter" => "JsonLogFormatter", "level" => Logger::INFO)
        expect(JSON.parse(result[:entry])).to include(
          "level" => "INFO",
          "service" => "check-client-qualifies",
          "environment" => "production",
          "correlationId" => "smoke-request-id",
          "message" => "JSON logging smoke probe",
          "context" => { "statusCode" => 200, "tags" => %w[smoke-request-id] },
        )
        expect(result[:logs]).not_to include("DEBUG logging smoke probe")
      end
    end

    it "keeps standalone production formatting unchanged" do
      result = boot_logging(mode: "standalone", environment: "production")

      expect(result[:configuration]).to include("formatter" => "Logger::Formatter", "level" => Logger::INFO)
      expect(result[:entry]).to include("[smoke-request-id]")
      expect { JSON.parse(result[:entry]) }.to raise_error(JSON::ParserError)
    end

    %w[development test].each do |environment|
      it "keeps embedded #{environment} formatting unchanged" do
        result = boot_logging(mode: "embedded", environment:, to_stdout: false)

        expect(result[:configuration]["formatter"]).not_to eq("JsonLogFormatter")
        expect(result[:entry]).to include("[smoke-request-id]")
        expect { JSON.parse(result[:entry]) }.to raise_error(JSON::ParserError)
      end
    end
  end
end
