require "rails_helper"

RSpec.describe CannotUseServiceController, type: :controller do
  let(:assessment_code) { "123456" }
  let(:step) { "additional_property" }
  let(:session_data) { { "some" => "data", "assessment_code" => assessment_code } }

  before do
    allow(controller).to receive(:session_data).and_return(session_data)
  end

  describe "GET #additional_properties" do
    it "returns success" do
      get :additional_properties, params: { assessment_code:, step: }
      expect(response).to have_http_status(200)
    end

    it "renders the additional properties template" do
      get :additional_properties, params: { assessment_code:, step: }
      expect(response).to render_template("additional_properties")
    end

    it "tracks the page view" do
      expect(controller).to receive(:track_page_view).with(page: "cannot-use-service_additional_property")
      get :additional_properties, params: { assessment_code:, step: }
    end

    context "when the previous step is partner_additional_property" do
      let(:step) { "partner_additional_property" }

      it "tracks the page view" do
        expect(controller).to receive(:track_page_view).with(page: "cannot-use-service_partner_additional_property")
        get :additional_properties, params: { assessment_code:, step: }
      end
    end
  end
end
