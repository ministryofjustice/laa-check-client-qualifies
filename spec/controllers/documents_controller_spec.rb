require "rails_helper"

RSpec.describe DocumentsController, type: :controller do
  describe "GET #show" do
    it "tracks the link if there is a subsection" do
      get :show, params: { id: "lc_guidance_controlled", sub_section: "asylum_support", assessment_code: "foo", referrer: "other_income" }
      expect(AnalyticsEvent.find_by(page: "other_income", event_type: "click_lc_guidance_controlled_asylum_support", assessment_code: "foo")).not_to be_nil
      expect(response.headers["Location"]).to eq "https://assets.publishing.service.gov.uk/media/673602d2b613efc3f182312e/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_November_2024.pdf#page=7"
    end

    it "tracks the link if there is no subsection" do
      get :show, params: { id: "lc_guidance_controlled", assessment_code: "foo", referrer: "other_income" }
      expect(AnalyticsEvent.find_by(page: "other_income", event_type: "click_lc_guidance_controlled", assessment_code: "foo")).not_to be_nil
      expect(response.headers["Location"]).to eq "https://assets.publishing.service.gov.uk/media/673602d2b613efc3f182312e/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_November_2024.pdf"
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
      expect(response.headers["Location"]).to eq "https://assets.publishing.service.gov.uk/media/673602d2b613efc3f182312e/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_November_2024.pdf"
    end
  end
end
