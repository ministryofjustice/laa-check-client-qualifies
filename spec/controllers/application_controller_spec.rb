require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  describe "#check_maintenance_mode" do
    it 'redirects to "/500" when maintenance mode is enabled' do
      allow(FeatureFlags).to receive(:enabled?).with(:maintenance_mode, without_session_data: true).and_return(true)
      expect(controller).to receive(:redirect_to).with("/500")

      controller.send(:check_maintenance_mode)
    end

    it 'does not redirect to "/500" when maintenance mode is not enabled' do
      allow(FeatureFlags).to receive(:enabled?).with(:maintenance_mode, without_session_data: true).and_return(false)
      expect(controller).not_to receive(:redirect_to)

      controller.send(:check_maintenance_mode)
    end
  end
end
