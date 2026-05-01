require "rails_helper"

RSpec.describe "mode_config" do
  describe "ModeConfig" do
    before do
      ModeConfig.instance_variable_set(:@mode, nil)
    end

    it "returns the correct capabilities for embedded mode" do
      expect(ModeConfig.database_enabled?).to be(false)
      expect(ModeConfig.admin_enabled?).to be(false)
      expect(ModeConfig.oauth_enabled?).to be(false)
      expect(ModeConfig.analytics_enabled?).to be(false)
      expect(ModeConfig.document_generation_enabled?).to be(false)
      expect(ModeConfig.authenticated_flow_enabled?).to be(true)

      expect(ModeConfig.cache_store).to eq([:redis_cache_store, { namespace: "ccq-embedded", url: "redis://localhost:6379/1" }])
    end
  end
end
