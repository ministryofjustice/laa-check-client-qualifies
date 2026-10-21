require "rails_helper"
require "stringio"
require "action_view/testing/resolvers"

RSpec.describe "embedded outcome logging", :embedded_only, ccq_mode: :embedded, type: :request do
  let(:resource_id) { "synthetic-case" }
  let(:sentinel) { "SYNTHETIC-PRIVATE-DO-NOT-LOG" }
  let(:headers) { { "Cookie" => "service.sid=#{sentinel}", "X-Request-Id" => "synthetic-request" } }
  let(:output) { StringIO.new }
  let(:logger) do
    base_logger = ActiveSupport::Logger.new(output)
    base_logger.formatter = JsonLogFormatter.new(environment: "test")
    ActiveSupport::TaggedLogging.new(base_logger)
  end
  let(:store) { instance_double(JourneyDataStore::RedisStore) }
  let(:client) { instance_double(HostServiceClient) }
  let(:session_data) { { "level_of_help" => "controlled", "immigration_or_asylum" => false, "client_age" => ClientAgeForm::STANDARD } }

  around do |example|
    original_view_paths = [EmbeddedLandingsController, EmbeddedResultsController, EmbeddedFormsController].index_with(&:view_paths)
    resolver = ActionView::FixtureResolver.new(
      "layouts/application.html.erb" => "<%= yield %>",
      "errors/session_expired.html.erb" => "Session expired",
      "errors/access_denied.html.erb" => "Access denied",
      "errors/service_unavailable.html.erb" => "Service unavailable",
      "question_flow/client_age.html.erb" => "Client age",
    )
    original_view_paths.each_key { |controller_class| controller_class.prepend_view_path(resolver) }
    example.run
  ensure
    original_view_paths.each { |controller_class, paths| controller_class.view_paths = paths }
  end

  before do
    allow(Rails).to receive(:logger).and_return(logger)
    allow(JourneyDataStore::RedisStore).to receive(:new).and_return(store)
    allow(store).to receive_messages(read: session_data, write: true, delete: true)
    allow(HostServiceClient).to receive(:new).and_return(client)
    allow(client).to receive_messages(load: double(status: 200, body: {}), save: double(status: 200))
  end

  def entries
    output.string.lines.map { |line| JSON.parse(line) }
  end

  def events
    entries.select { |entry| entry.dig("context", "event") }
  end

  def perform_request(operation: :load, resource: resource_id, request_headers: headers, env: {})
    path = "/cases/#{resource}/eligibility"
    path += "/complete" if operation == :save
    public_send(operation == :load ? :get : :post, path, headers: request_headers,
                                                         env: { "action_dispatch.logger" => logger }.merge(env))
  end

  it "logs a fresh journey once after hydration with its request and case identifiers" do
    perform_request

    expect(response).to be_redirect
    expect(events.size).to eq(1)
    expect(events.first).to include("level" => "INFO", "correlationId" => "synthetic-request", "message" => "Embedded journey started")
    expect(events.first["context"]).to include("event" => "embedded.journey.started", "caseId" => resource_id, "operation" => "embedded.journey.load")
    expect(output.string).not_to include(sentinel)
  end

  it "logs a resumed journey once after hydration" do
    allow(client).to receive(:load).and_return(double(status: 200, body: { "data" => session_data, "result" => { "eligible" => true } }))

    perform_request

    expect(response).to redirect_to(result_path(resource_id:))
    expect(events.map { |entry| entry.dig("context", "event") }).to eq(%w[embedded.journey.resumed])
  end

  it "uses Rails' generated request ID when no request ID was supplied" do
    perform_request(request_headers: headers.except("X-Request-Id"))

    expect(events.first["correlationId"]).to be_present
    expect(events.first["correlationId"]).to eq(response.headers["X-Request-Id"])
  end

  it "keeps sequential cases and request IDs separate" do
    perform_request
    perform_request(resource: "second-case", request_headers: headers.merge("X-Request-Id" => "second-request"))

    expect(events.map { |entry| [entry["correlationId"], entry.dig("context", "caseId")] }).to eq(
      [["synthetic-request", resource_id], %w[second-request second-case]],
    )
  end

  it "does not add outcome events to an ordinary form request" do
    perform_request
    form_path = step_path(resource_id:, step_url_fragment: Flow::Handler.url_fragment(:client_age))
    output.truncate(0)
    output.rewind
    allow(store).to receive(:read).and_return(session_data.except("client_age"))

    get form_path, headers:, env: { "action_dispatch.logger" => logger }

    expect(response).to have_http_status(:ok)
    expect(events).to be_empty
  end

  %i[load save].each do |operation|
    describe "host #{operation}" do
      [[401, "WARN", "security.authentication.failed", :unauthorized],
       [403, "WARN", "security.authorisation.denied", :forbidden],
       [500, "ERROR", "embedded.host.request.failed", :service_unavailable],
       [418, "ERROR", "embedded.host.request.failed", :service_unavailable]].each do |status, level, event, http_status|
        it "logs status #{status} exactly once without exposing the response" do
          allow(client).to receive(operation).and_return(double(status:, body: { error: sentinel }))

          perform_request(operation:)

          expect(response).to have_http_status(http_status)
          expect(events.size).to eq(1)
          expect(events.first).to include("level" => level)
          expect(events.first["context"]).to include("event" => event, "statusCode" => status,
                                                     "dependency" => "host-service", "operation" => "embedded.journey.#{operation}")
          expect(output.string).not_to include(sentinel)
        end
      end

      it "logs a transport failure once without an invented status code or exception message" do
        allow(client).to receive(operation).and_raise(HostServiceClient::ConnectionError, sentinel)

        perform_request(operation:)

        expect(response).to have_http_status(:service_unavailable)
        expect(events.size).to eq(1)
        expect(events.first).to include("level" => "ERROR")
        expect(events.first["context"]).to include("event" => "embedded.host.request.failed", "reason" => "transport_error")
        expect(events.first["context"]).not_to have_key("statusCode")
        expect(output.string).not_to include(sentinel)
      end

      [[nil, "missing_location"], ["invalid://[]", "invalid_location"], ["https://disallowed.example/auth", "disallowed_location"]].each do |location, reason|
        it "rejects #{reason} once without logging the supplied redirect" do
          private_location = location && "#{location}?token=#{sentinel}"
          allow(client).to receive(operation).and_return(double(status: 302, headers: { "location" => private_location }))

          perform_request(operation:)

          expect(response).to have_http_status(:service_unavailable)
          expect(events.size).to eq(1)
          expect(events.first).to include("level" => "ERROR")
          expect(events.first["context"]).to include("event" => "embedded.host.redirect_rejected", "reason" => reason, "statusCode" => 302)
          expect(output.string).not_to include(sentinel)
        end
      end

      it "logs valid reauthentication once and preserves its redirect" do
        allow(client).to receive(operation).and_return(double(status: 302, headers: { "location" => "/auth/sign-in?prompt=login" }))

        perform_request(operation:)

        expect(response).to be_redirect
        expect(URI.parse(response.location).path).to eq("/auth/sign-in")
        expect(events.size).to eq(1)
        expect(events.first).to include("level" => "INFO")
        expect(events.first["context"]).to include("event" => "security.authentication.required", "statusCode" => 302)
      end
    end
  end

  it "logs completion only after the host save and cache deletion" do
    allow(store).to receive(:delete) do
      expect(events).to be_empty
      expect(client).to have_received(:save).once
      true
    end

    perform_request(operation: :save)

    expect(response).to redirect_to("/cases/#{resource_id}/task-list")
    expect(events.size).to eq(1)
    expect(events.first).to include("level" => "INFO", "message" => "Embedded journey completed")
    expect(events.first["context"]).to include("event" => "embedded.journey.completed")
    expect(store).not_to have_received(:write)
  end

  [false, :raise].each do |failure|
    it "does not log completion when cache deletion returns #{failure}" do
      if failure == :raise
        allow(store).to receive(:delete).and_raise("Synthetic cache failure")
      else
        allow(store).to receive(:delete).and_return(false)
      end

      if failure == :raise
        expect { perform_request(operation: :save) }.to raise_error(RuntimeError, "Synthetic cache failure")
      else
        perform_request(operation: :save)
        expect(response).to be_redirect
      end

      expect(events).to be_empty
    end

    [false, true].each do |resumed|
      it "does not report hydration success when the initial cache write returns #{failure}, resumed=#{resumed}" do
        body = resumed ? { "data" => session_data, "result" => {} } : {}
        allow(client).to receive(:load).and_return(double(status: 200, body:))
        if failure == :raise
          allow(store).to receive(:write).and_raise("Synthetic cache failure")
        else
          allow(store).to receive(:write).and_return(false)
        end

        if failure == :raise
          expect { perform_request }.to raise_error(RuntimeError, "Synthetic cache failure")
        else
          perform_request
        end

        expect(events).to be_empty
      end
    end

    it "does not report a fresh journey before the after-action cache write succeeds, failure=#{failure}" do
      writes = 0
      allow(store).to receive(:write) do
        writes += 1
        expect(events).to be_empty
        raise "Synthetic cache failure" if writes == 2 && failure == :raise

        writes != 2
      end

      if failure == :raise
        expect { perform_request }.to raise_error(RuntimeError, "Synthetic cache failure")
      else
        perform_request
      end

      expect(writes).to eq(2)
      expect(events).to be_empty
    end
  end

  it "logs missing hydration sessions once and preserves the unauthorized page" do
    allow(store).to receive(:write).and_raise(JourneyDataStore::KeyNotFound)

    perform_request

    expect(response).to have_http_status(:unauthorized)
    expect(events.size).to eq(1)
    expect(events.first).to include("level" => "WARN")
    expect(events.first.dig("context", "event")).to eq("embedded.session.missing")
  end

  [[ApplicationController::MissingSessionError.new, "embedded.session.missing"],
   [Cfe::InvalidSessionError.new(ApplicantForm.new), "embedded.session.invalid"]].each do |error, event|
    it "logs #{event} once when the existing recovery handler redirects" do
      allow(store).to receive(:read).and_raise(error)

      perform_request(operation: :save)

      expect(response).to redirect_to(landing_path(resource_id:))
      expect(events.size).to eq(1)
      expect(events.first).to include("level" => "WARN")
      expect(events.first.dig("context", "event")).to eq(event)
      expect(client).not_to have_received(:save)
    end
  end

  %i[unexpected cfe].each do |source|
    it "leaves #{source} exception logging to Rails once with its stack trace" do
      if source == :unexpected
        allow(client).to receive(:load).and_raise(RuntimeError, "Synthetic unexpected failure")
      else
        allow(CfeConnection).to receive(:cfe_connection).and_return(double(post: double(success?: false, status: 422, body: sentinel)))
        allow(CfeService).to receive(:call) { CfeConnection.assess({}) }
      end
      path = "/cases/#{resource_id}/eligibility#{source == :cfe ? '/check-result' : ''}"
      exception_env = {
        "action_dispatch.logger" => logger,
        "action_dispatch.show_exceptions" => :all,
        "action_dispatch.show_detailed_exceptions" => false,
        "action_dispatch.log_rescued_responses" => true,
      }
      allow(Rails.application).to receive(:env_config).and_return(Rails.application.env_config.merge(exception_env))
      source == :cfe ? post(path, headers:, env: exception_env) : get(path, headers:, env: exception_env)

      expect(response).to have_http_status(:internal_server_error)
      expect(events).to be_empty
      exception_entries = entries.select { |entry| entry["message"].include?(source == :cfe ? "Call to CFE returned status 422" : "Synthetic unexpected failure") }
      expect(exception_entries.size).to eq(1)
      expect(exception_entries.first["message"]).to include("RuntimeError", "app/")
      expect(output.string).not_to include(sentinel)
    end
  end
end
