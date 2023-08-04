require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  def check_maintenance_mode
    true
  end

  describe "#check_maintenance_mode" do
    it "displays the correct content from maintenace page" do
      expect(response).to eq("Sorry")
    end
  end
end
