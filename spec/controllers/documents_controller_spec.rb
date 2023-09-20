require "rails_helper"

RSpec.describe DocumentsController, type: :controller do
  describe "GET #show" do
    it "tracks the link if there is a subsection" do
      get :show, params: { id: "lc_guidance_controlled", sub_section: "asylum_support", assessment_code: "foo", referrer: "other" }
      expect(AnalyticsEvent.find_by(page: "other", event_type: "click_lc_guidance_controlled_asylum_support", assessment_code: "foo")).not_to be_nil
      expect(response.headers["Location"]).to eq "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1176119/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation__August_2023_.pdf#page=7"
    end

    it "tracks the link if there is no subsection" do
      get :show, params: { id: "lc_guidance_controlled", assessment_code: "foo", referrer: "other" }
      expect(AnalyticsEvent.find_by(page: "other", event_type: "click_lc_guidance_controlled", assessment_code: "foo")).not_to be_nil
      expect(response.headers["Location"]).to eq "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1176119/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation__August_2023_.pdf"
    end

    it "tracks the CW forms link and redirects successfully" do
      get :show, params: { id: "laa_cw_forms", assessment_code: "foo", referrer: "other" }
      expect(AnalyticsEvent.find_by(page: "other", event_type: "click_laa_cw_forms", assessment_code: "foo")).not_to be_nil
      expect(response.headers["Location"]).to eq "https://www.gov.uk/government/collections/controlled-work-application-forms"
    end

    it "tracks nothing if there is no referrer param" do
      get :show, params: { id: "lc_guidance_controlled", assessment_code: "foo" }
      expect(AnalyticsEvent.find_by(event_type: "click_lc_guidance_controlled", assessment_code: "foo")).to be_nil
      expect(response.headers["Location"]).to eq "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1176119/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation__August_2023_.pdf"
    end
  end
end
