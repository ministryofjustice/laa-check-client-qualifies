require "rails_helper"

RSpec.describe EmbeddedBaseController, ccq_mode: :embedded, type: :controller do
  let(:resource_id) { "test_resource_id" }
  let(:session_id) { "test_session_id" }
  let(:controller) { described_class.new.tap { |c| c.params = { resource_id: resource_id } } }
  let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }
  let(:logger) { object_double(Rails.logger, info: nil, warn: nil, error: nil) }

  before do
    allow(Rails).to receive(:logger).and_return(logger)
    allow(logger).to receive(:tagged).and_yield
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("HOST_SERVICE_SESSION_COOKIES", "").and_return("service.sid")
    allow(controller).to receive_messages(
      request: instance_double(ActionDispatch::Request, request_id: "test-request-id", headers: {}),
      cookies: { "service.sid" => session_id },
    )
    allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id, session_id).and_return(journey_store)
  end

  describe "#log_embedded_event", :embedded_only do
    let(:logger) { object_double(Rails.logger, warn: nil) }

    before do
      allow(Rails).to receive(:logger).and_return(logger)
      allow(controller).to receive(:request).and_return(instance_double(ActionDispatch::Request, request_id: "test-request-id", headers: {}))
    end

    it "adds request and case context without serializing the event" do
      controller.send(:log_embedded_event, :warn, event: "security.authentication.failed",
                                                  message: "Host authentication failed", operation: "embedded.journey.load",
                                                  dependency: "host-service", statusCode: 401)

      expect(logger).to have_received(:warn).once.with(
        message: "Host authentication failed",
        correlationId: "test-request-id",
        context: {
          event: "security.authentication.failed",
          operation: "embedded.journey.load",
          caseId: resource_id,
          dependency: "host-service",
          statusCode: 401,
        },
      )
    end

    it "omits unavailable status codes" do
      controller.send(:log_embedded_event, :warn, event: "embedded.session.missing",
                                                  message: "Embedded session missing", operation: "embedded.session.recover", statusCode: nil)

      expect(logger).to have_received(:warn).once.with(hash_including(
                                                         context: { event: "embedded.session.missing", operation: "embedded.session.recover", caseId: resource_id },
                                                       ))
    end
  end

  describe "#session_data", :embedded_only do
    context "when session data is present" do
      let(:session_data) { { "key" => "value" } }

      before do
        allow(journey_store).to receive(:read).and_return(session_data)
      end

      it "returns the session data" do
        expect(controller.send(:session_data)).to eq(session_data)
      end
    end

    context "when session data is missing" do
      before do
        allow(journey_store).to receive(:read).and_raise(JourneyDataStore::KeyNotFound)
      end

      it "raises MissingSessionError" do
        expect { controller.send(:session_data) }.to raise_error(ApplicationController::MissingSessionError)
      end
    end
  end

  describe "#persist_journey_data", :embedded_only do
    let(:session_data_cache) { { "key" => "value" } }

    before do
      controller.instance_variable_set(:@session_data_cache, session_data_cache)
      allow(journey_store).to receive(:write)
      controller.send(:persist_journey_data)
    end

    it "writes the session data cache to the journey store" do
      expect(journey_store).to have_received(:write).with(session_data_cache)
    end
  end

  describe "#tag_logs_with_resource_id", :embedded_only do
    it "tags logs with the resource_id" do
      expect(Rails.logger).to receive(:tagged).with("resource_id:#{resource_id}", any_args)
      controller.send(:tag_logs_with_resource_id) {}
    end
  end

  describe "#journey_store", :embedded_only do
    it "initializes a JourneyDataStore::RedisStore with the resource_id and host service session id" do
      expect(JourneyDataStore::RedisStore).to receive(:new).with(resource_id, session_id)
      controller.send(:journey_store)
    end

    it "uses the first matching configured host service cookie" do
      allow(ENV).to receive(:fetch).with("HOST_SERVICE_SESSION_COOKIES", "").and_return("other.sid, service.sid")
      allow(controller).to receive(:cookies).and_return(
        { "other.sid" => "configured_session_id", "service.sid" => session_id },
      )

      expect(JourneyDataStore::RedisStore).to receive(:new).with(resource_id, "configured_session_id")
      controller.send(:journey_store)
    end

    it "does not use an unconfigured cookie" do
      allow(ENV).to receive(:fetch).with("HOST_SERVICE_SESSION_COOKIES", "").and_return("other.sid")

      expect(JourneyDataStore::RedisStore).to receive(:new).with(resource_id, nil)
      controller.send(:journey_store)
    end
  end

  describe "#assessment_code", :embedded_only do
    it "returns the resource_id as the assessment code" do
      expect(controller.send(:assessment_code)).to eq(resource_id)
    end
  end

  describe "#embedded_layout_path", :embedded_only do
    let(:lookup_context) { instance_double(ActionView::LookupContext) }

    before do
      allow(controller).to receive(:lookup_context).and_return(lookup_context)
    end

    it "returns the configured layout when it exists" do
      allow(ModeConfig).to receive(:embedded_layout).and_return("application")
      allow(lookup_context).to receive(:exists?).with("application", %w[layouts], false).and_return(true)

      expect(controller.send(:embedded_layout_path)).to eq("application")
    end

    it "returns a namespaced layout name when it exists" do
      allow(ModeConfig).to receive(:embedded_layout).and_return("rcw/application")
      allow(lookup_context).to receive(:exists?).with("rcw/application", %w[layouts], false).and_return(true)

      expect(controller.send(:embedded_layout_path)).to eq("rcw/application")
    end

    it "raises an error when the configured layout does not exist" do
      allow(ModeConfig).to receive(:embedded_layout).and_return("host_service")
      allow(lookup_context).to receive(:exists?).with("host_service", %w[layouts], false).and_return(false)

      expect {
        controller.send(:embedded_layout_path)
      }.to raise_error(
        ArgumentError,
        "Unknown embedded layout 'host_service'. Expected app/views/layouts/<layout_path>.html.*",
      )
    end
  end

  describe "#redirect_to_host_reauthentication", :embedded_only do
    let(:request_path) { "/cases/#{resource_id}/eligibility" }
    let(:request_original_fullpath) { request_path }
    let(:request_host) { "test.host" }

    before do
      allow(Rails).to receive(:logger).and_return(logger)
      allow(logger).to receive(:tagged).and_yield
      allow(controller).to receive(:request).and_return(
        instance_double(
          ActionDispatch::Request,
          path: request_path,
          original_fullpath: request_original_fullpath,
          host: request_host,
          request_id: "test-request-id",
          headers: {},
        ),
      )
    end

    it "redirects to the host location and appends returnTo" do
      expect(controller).to receive(:redirect_to).with(
        "https://test.host/auth/sign-in?prompt=login&returnTo=%2Fcases%2F#{resource_id}%2Feligibility",
      )

      controller.send(
        :redirect_to_host_reauthentication,
        location: "https://test.host/auth/sign-in?prompt=login",
      )
    end

    it "allows relative reauthentication locations" do
      expect(controller).to receive(:redirect_to).with(
        "/auth/sign-in?prompt=login&returnTo=%2Fcases%2F#{resource_id}%2Feligibility",
      )

      controller.send(
        :redirect_to_host_reauthentication,
        location: "/auth/sign-in?prompt=login",
      )
    end

    it "uses original_fullpath path when request.path is rewritten" do
      allow(controller).to receive(:request).and_return(
        instance_double(
          ActionDispatch::Request,
          path: "/cases/#{resource_id}",
          original_fullpath: "/cases/#{resource_id}/eligibility?from=host",
          host: request_host,
          request_id: "test-request-id",
          headers: {},
        ),
      )

      expect(controller).to receive(:redirect_to).with(
        "https://test.host/auth/sign-in?returnTo=%2Fcases%2F#{resource_id}%2Feligibility",
      )

      controller.send(
        :redirect_to_host_reauthentication,
        location: "https://test.host/auth/sign-in",
      )
    end

    it "preserves the destination query param while stripping other query params" do
      allow(controller).to receive(:request).and_return(
        instance_double(
          ActionDispatch::Request,
          path: "/cases/#{resource_id}/eligibility",
          original_fullpath: "/cases/#{resource_id}/eligibility?from=host&destination=check-answers",
          host: request_host,
          request_id: "test-request-id",
          headers: {},
        ),
      )

      expect(controller).to receive(:redirect_to).with(
        "https://test.host/auth/sign-in?returnTo=%2Fcases%2F#{resource_id}%2Feligibility%3Fdestination%3Dcheck-answers",
      )

      controller.send(
        :redirect_to_host_reauthentication,
        location: "https://test.host/auth/sign-in",
      )
    end

    it "falls back to request.path when original_fullpath is invalid" do
      allow(controller).to receive(:request).and_return(
        instance_double(
          ActionDispatch::Request,
          path: "/cases/#{resource_id}/eligibility",
          original_fullpath: "http://%",
          host: request_host,
          request_id: "test-request-id",
          headers: {},
        ),
      )

      expect(controller).to receive(:redirect_to).with(
        "https://test.host/auth/sign-in?returnTo=%2Fcases%2F#{resource_id}%2Feligibility",
      )

      controller.send(
        :redirect_to_host_reauthentication,
        location: "https://test.host/auth/sign-in",
      )
    end

    it "falls back to request.path when original_fullpath is blank" do
      allow(controller).to receive(:request).and_return(
        instance_double(
          ActionDispatch::Request,
          path: "/cases/#{resource_id}/eligibility",
          original_fullpath: nil,
          host: request_host,
          request_id: "test-request-id",
          headers: {},
        ),
      )

      expect(controller).to receive(:redirect_to).with(
        "https://test.host/auth/sign-in?returnTo=%2Fcases%2F#{resource_id}%2Feligibility",
      )

      controller.send(
        :redirect_to_host_reauthentication,
        location: "https://test.host/auth/sign-in",
      )
    end

    it "renders service unavailable without logging the unexpected location" do
      sentinel = "SYNTHETIC-REDIRECT-HOST-DO-NOT-LOG"
      expect(controller).to receive(:render).with("errors/service_unavailable", status: :service_unavailable)

      controller.send(
        :redirect_to_host_reauthentication,
        location: "https://login.example.com/auth/sign-in?token=#{sentinel}",
      )

      expect(logger).to have_received(:error).once.with(hash_including(
                                                          context: hash_including(event: "embedded.host.redirect_rejected", reason: "disallowed_location", statusCode: 302),
                                                        ))
      expect(logger).not_to have_received(:warn)
    end

    it "renders service unavailable and logs when location is missing" do
      expect(logger).to receive(:error).once.with(hash_including(
                                                    context: hash_including(event: "embedded.host.redirect_rejected", reason: "missing_location", statusCode: 302),
                                                  ))
      expect(controller).to receive(:render).with("errors/service_unavailable", status: :service_unavailable)

      controller.send(
        :redirect_to_host_reauthentication,
        location: nil,
      )
    end

    it "renders service unavailable without logging the invalid location" do
      sentinel = "SYNTHETIC-REDIRECT-INVALID-DO-NOT-LOG"
      expect(controller).to receive(:render).with("errors/service_unavailable", status: :service_unavailable)

      controller.send(
        :redirect_to_host_reauthentication,
        location: "invalid://[]?token=#{sentinel}",
      )

      expect(logger).to have_received(:error).once.with(hash_including(
                                                          context: hash_including(event: "embedded.host.redirect_rejected", reason: "invalid_location", statusCode: 302),
                                                        ))
      expect(logger).not_to have_received(:warn)
    end

    it "does not log authentication required if Rails rejects the redirect" do
      allow(controller).to receive(:redirect_to).and_raise(ActionController::Redirecting::UnsafeRedirectError)
      expect(controller).to receive(:render).with("errors/service_unavailable", status: :service_unavailable)

      controller.send(:redirect_to_host_reauthentication, location: "/auth/sign-in")

      expect(logger).to have_received(:error).once.with(hash_including(
                                                          context: hash_including(event: "embedded.host.redirect_rejected", reason: "invalid_location"),
                                                        ))
      expect(logger).not_to have_received(:info)
    end
  end

  describe "rescue_from Cfe::InvalidSessionError", :embedded_only do
    it "redirects to the embedded landing page" do
      expect(controller).to receive(:redirect_to).with(:landing)
      controller.send(:rescue_with_handler, Cfe::InvalidSessionError.new(ApplicantForm.new))

      expect(logger).to have_received(:warn).once.with(hash_including(context: hash_including(event: "embedded.session.invalid")))
    end
  end

  describe "rescue_from ApplicationController::MissingSessionError", :embedded_only do
    it "redirects to the embedded landing page" do
      expect(controller).to receive(:redirect_to).with(:landing)
      controller.send(:rescue_with_handler, ApplicationController::MissingSessionError.new(ApplicantForm.new))

      expect(logger).to have_received(:warn).once.with(hash_including(context: hash_including(event: "embedded.session.missing")))
    end
  end
end
