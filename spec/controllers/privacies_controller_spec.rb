require "rails_helper"

RSpec.describe PrivaciesController, type: :controller do
  describe "GET #show" do
    it "tracks the page view" do
      expect(controller).to receive(:track_page_view)
      get :show
    end
  end
end
