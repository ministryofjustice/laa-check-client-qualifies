require "rails_helper"

RSpec.describe EmbeddedBaseController, ccq_mode: :embedded, type: :controller do
  let(:resource_id) { "test_resource_id" }
  let(:controller) { described_class.new.tap { |c| c.params = { resource_id: resource_id } } }
  let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }

  before do
    allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
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
    it "initializes a JourneyDataStore::RedisStore with the resource_id" do
      expect(JourneyDataStore::RedisStore).to receive(:new).with(resource_id)
      controller.send(:journey_store)
    end
  end

  describe "#assessment_code", :embedded_only do
    it "returns the resource_id as the assessment code" do
      expect(controller.send(:assessment_code)).to eq(resource_id)
    end
  end

  describe "#embedded_layout_name", :embedded_only do
    let(:lookup_context) { instance_double(ActionView::LookupContext) }

    before do
      allow(controller).to receive(:lookup_context).and_return(lookup_context)
    end

    it "returns the configured layout when it exists" do
      allow(ModeConfig).to receive(:embedded_layout).and_return("application")
      allow(lookup_context).to receive(:exists?).with("application", %w[layouts], false).and_return(true)

      expect(controller.send(:embedded_layout_name)).to eq("application")
    end

    it "returns a namespaced layout name when it exists" do
      allow(ModeConfig).to receive(:embedded_layout).and_return("rcw/application")
      allow(lookup_context).to receive(:exists?).with("rcw/application", %w[layouts], false).and_return(true)

      expect(controller.send(:embedded_layout_name)).to eq("rcw/application")
    end

    it "raises an error when the configured layout does not exist" do
      allow(ModeConfig).to receive(:embedded_layout).and_return("host_service")
      allow(lookup_context).to receive(:exists?).with("host_service", %w[layouts], false).and_return(false)

      expect {
        controller.send(:embedded_layout_name)
      }.to raise_error(ArgumentError, "Unknown embedded layout 'host_service'. Expected app/views/layouts/host_service.html.*")
    end
  end

  describe "#redirect_to_host_reauthentication", :embedded_only do
    let(:logger) { object_double(Rails.logger, warn: nil) }
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

    it "falls back to request.path when original_fullpath is invalid" do
      allow(controller).to receive(:request).and_return(
        instance_double(
          ActionDispatch::Request,
          path: "/cases/#{resource_id}/eligibility",
          original_fullpath: "http://%",
          host: request_host,
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

    it "renders service unavailable and logs when location host is unexpected" do
      expect(logger).to receive(:warn).with(
        include("EmbeddedBaseController received reauthentication Location with unexpected host from HostServiceClient"),
      )
      expect(controller).to receive(:render).with("errors/service_unavailable", status: :service_unavailable)

      controller.send(
        :redirect_to_host_reauthentication,
        location: "https://login.example.com/auth/sign-in",
      )
    end

    it "renders service unavailable and logs when location is missing" do
      expect(logger).to receive(:warn).with(
        "EmbeddedBaseController received 302 from HostServiceClient without a Location header",
      )
      expect(controller).to receive(:render).with("errors/service_unavailable", status: :service_unavailable)

      controller.send(
        :redirect_to_host_reauthentication,
        location: nil,
      )
    end

    it "renders service unavailable and logs when location is invalid" do
      expect(logger).to receive(:warn).with(
        include("EmbeddedBaseController received invalid reauthentication Location from HostServiceClient"),
      )
      expect(controller).to receive(:render).with("errors/service_unavailable", status: :service_unavailable)

      controller.send(
        :redirect_to_host_reauthentication,
        location: "invalid://[]",
      )
    end
  end

  describe "rescue_from Cfe::InvalidSessionError", :embedded_only do
    it "redirects to the embedded landing page" do
      expect(controller).to receive(:redirect_to).with(:landing)
      controller.send(:rescue_with_handler, Cfe::InvalidSessionError.new(ApplicantForm.new))
    end
  end

  describe "rescue_from ApplicationController::MissingSessionError", :embedded_only do
    it "redirects to the embedded landing page" do
      expect(controller).to receive(:redirect_to).with(:landing)
      controller.send(:rescue_with_handler, ApplicationController::MissingSessionError.new(ApplicantForm.new))
    end
  end
end
