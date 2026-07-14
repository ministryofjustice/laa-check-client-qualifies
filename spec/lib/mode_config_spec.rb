require "rails_helper"

RSpec.describe "mode_config" do
  describe "ModeConfig" do
    before do
      ModeConfig.instance_variable_set(:@mode, nil)
    end

    it "returns the correct capabilities for standalone mode" do
      allow(ENV).to receive(:fetch).with("CCQ_MODE", anything).and_return("standalone")
      expect(ModeConfig.database_enabled?).to be(true)
      expect(ModeConfig.admin_enabled?).to be(true)
      expect(ModeConfig.oauth_enabled?).to be(true)
      expect(ModeConfig.analytics_enabled?).to be(true)
      expect(ModeConfig.document_generation_enabled?).to be(true)
      expect(ModeConfig.authenticated_flow_enabled?).to be(false)

      expect(ModeConfig.cache_store).to eq(:solid_cache_store)
    end

    it "returns the correct capabilities for embedded mode" do
      allow(ENV).to receive(:fetch).with("CCQ_MODE", anything).and_return("embedded")
      expect(ModeConfig.database_enabled?).to be(false)
      expect(ModeConfig.admin_enabled?).to be(false)
      expect(ModeConfig.oauth_enabled?).to be(false)
      expect(ModeConfig.analytics_enabled?).to be(false)
      expect(ModeConfig.document_generation_enabled?).to be(false)
      expect(ModeConfig.authenticated_flow_enabled?).to be(true)

      expect(ModeConfig.cache_store).to eq([:redis_cache_store, { namespace: "ccq-embedded", url: "redis://localhost:6379/#{ENV['TEST_ENV_NUMBER'].presence || 1}" }])
    end

    it "raises an error for an unknown mode" do
      allow(ENV).to receive(:fetch).with("CCQ_MODE", anything).and_return("unknown")
      expect { ModeConfig.mode }.to raise_error(ArgumentError, "Unknown CCQ_MODE: unknown")
    end

    describe ".embedded_layout" do
      it "uses the default embedded layout when not set" do
        allow(ENV).to receive(:fetch).with("CCQ_EMBEDDED_LAYOUT", "application").and_return("application")

        expect(ModeConfig.embedded_layout).to eq("application")
      end

      it "returns the configured embedded layout name" do
        allow(ENV).to receive(:fetch).with("CCQ_EMBEDDED_LAYOUT", "application").and_return("host_service")

        expect(ModeConfig.embedded_layout).to eq("host_service")
      end

      it "allows underscore layout names" do
        allow(ENV).to receive(:fetch).with("CCQ_EMBEDDED_LAYOUT", "application").and_return("application_rcw")

        expect(ModeConfig.embedded_layout).to eq("application_rcw")
      end

      it "falls back to default when configured value is blank" do
        allow(ENV).to receive(:fetch).with("CCQ_EMBEDDED_LAYOUT", "application").and_return("   ")

        expect(ModeConfig.embedded_layout).to eq("application")
      end

      it "raises an error when configured value has invalid characters" do
        allow(ENV).to receive(:fetch).with("CCQ_EMBEDDED_LAYOUT", "application").and_return("../host")

        expect { ModeConfig.embedded_layout }.to raise_error(ArgumentError, "Invalid CCQ_EMBEDDED_LAYOUT: ../host")
      end

      it "raises an error when configured value contains dots" do
        allow(ENV).to receive(:fetch).with("CCQ_EMBEDDED_LAYOUT", "application").and_return("application.rcw")

        expect { ModeConfig.embedded_layout }.to raise_error(ArgumentError, "Invalid CCQ_EMBEDDED_LAYOUT: application.rcw")
      end
    end
  end
end
