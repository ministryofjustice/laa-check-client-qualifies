require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  describe "#check_maintenance_mode" do
    it "redirects to the maintenance page when maintenance mode is enabled" do
      # Mock the maintenance_mode_enabled variable to be true
      allow(controller).to receive(:maintenance_mode_enabled).and_return(true)

      # Expect that a redirect to "/maintenance" is performed
      expect(controller).to receive(:redirect_to).with("/maintenance")

      # Call the check_maintenance_mode method
      controller.check_maintenance_mode
    end
end
