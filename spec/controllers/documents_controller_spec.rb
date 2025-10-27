require "rails_helper"

RSpec.describe DocumentsController, type: :controller do
  describe "GET #show" do
    it "tracks the link if there is a subsection" do
      get :show, params: { id: "lc_guidance_controlled", sub_section: "asylum_support", assessment_code: "foo", referrer: "other_income" }
      expect(AnalyticsEvent.find_by(page: "other_income", event_type: "click_lc_guidance_controlled_asylum_support", assessment_code: "foo")).not_to be_nil
      expect(response.headers["Location"]).to eq "https://assets.publishing.service.gov.uk/media/684ff44229fb1002010c4e6c/LC_s_guidance_on_determining_financial_eligibility__controlled_and_mediation_.pdf#page=7"
    end

    it "tracks the link if there is no subsection" do
      get :show, params: { id: "lc_guidance_controlled", assessment_code: "foo", referrer: "other_income" }
      expect(AnalyticsEvent.find_by(page: "other_income", event_type: "click_lc_guidance_controlled", assessment_code: "foo")).not_to be_nil
      expect(response.headers["Location"]).to eq "https://assets.publishing.service.gov.uk/media/684ff44229fb1002010c4e6c/LC_s_guidance_on_determining_financial_eligibility__controlled_and_mediation_.pdf"
    end

    it "tracks the CW forms link and redirects successfully" do
      get :show, params: { id: "laa_cw_forms", assessment_code: "foo", referrer: "other_income" }
      expect(AnalyticsEvent.find_by(page: "other_income", event_type: "click_laa_cw_forms", assessment_code: "foo")).not_to be_nil
      expect(response.headers["Location"]).to eq "https://www.gov.uk/government/collections/controlled-work-application-forms"
    end

    it "tracks the legal aid public calculator link and redirects successfully" do
      get :show, params: { id: "legal_aid_checker_for_public", assessment_code: "foo", referrer: "other_income" }
      expect(AnalyticsEvent.find_by(page: "other_income", event_type: "click_legal_aid_checker_for_public", assessment_code: "foo")).not_to be_nil
      expect(response.headers["Location"]).to eq "https://www.gov.uk/check-legal-aid"
    end

    it "tracks nothing if there is no referrer param" do
      get :show, params: { id: "lc_guidance_controlled", assessment_code: "foo" }
      expect(AnalyticsEvent.find_by(event_type: "click_lc_guidance_controlled", assessment_code: "foo")).to be_nil
      expect(response.headers["Location"]).to eq "https://assets.publishing.service.gov.uk/media/684ff44229fb1002010c4e6c/LC_s_guidance_on_determining_financial_eligibility__controlled_and_mediation_.pdf"
    end

    context "when handling invalid document IDs" do
      it "returns 404 for unknown document IDs (e.g., bot probes)" do
        get :show, params: { id: "wp.php" }
        expect(response).to have_http_status(:not_found)
      end

      it "returns 404 for other common exploit attempts" do
        %w[admin.php index.php bypass.php alfa.php k.php].each do |malicious_id|
          get :show, params: { id: malicious_id }
          expect(response).to have_http_status(:not_found)
        end
      end

      it "does not track analytics for invalid document IDs" do
        get :show, params: { id: "wp.php", assessment_code: "foo", referrer: "some_page" }
        expect(AnalyticsEvent.find_by(assessment_code: "foo")).to be_nil
      end

      it "returns 404 for invalid subsections" do
        get :show, params: { id: "lc_guidance_controlled", sub_section: "nonexistent" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
