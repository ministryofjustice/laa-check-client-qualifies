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
    end

    it "returns the correct capabilities for embedded mode" do
      allow(ENV).to receive(:fetch).with("CCQ_MODE", anything).and_return("embedded")
      expect(ModeConfig.database_enabled?).to be(false)
      expect(ModeConfig.admin_enabled?).to be(false)
      expect(ModeConfig.oauth_enabled?).to be(false)
      expect(ModeConfig.analytics_enabled?).to be(false)
      expect(ModeConfig.document_generation_enabled?).to be(false)
      expect(ModeConfig.authenticated_flow_enabled?).to be(true)
    end

    it "raises an error for an unknown mode" do
      allow(ENV).to receive(:fetch).with("CCQ_MODE", anything).and_return("unknown")
      expect { ModeConfig.mode }.to raise_error(ArgumentError, "Unknown CCQ_MODE: unknown")
    end
  end
end
