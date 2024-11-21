require "rails_helper"

RSpec.describe ExternalLinkService do
  describe ".call" do
    it "shows controlled LC Guidance links" do
      result = described_class.call(document: :lc_guidance_controlled)
      expect(result).to eq "https://assets.publishing.service.gov.uk/media/673602d2b613efc3f182312e/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_November_2024.pdf"
    end

    it "shows certificated LC Guidance links" do
      result = described_class.call(document: :lc_guidance_certificated)
      expect(result).to eq "https://assets.publishing.service.gov.uk/media/673601dc37aabe56c416117e/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_Certificated_work_November_2024.pdf"
    end

    it "shows just the page number to the correct LC Guidance, when page_number_only: is true" do
      result = described_class.call(document: :lc_guidance_controlled, sub_section: :disregarded_payments, page_number_only: true)
      expect(result).to eq 15
    end

    it "takes me to a specific part of PDF in the certificated LC Guidance" do
      result = described_class.call(document: :lc_guidance_certificated, sub_section: :upper_tribunal)
      expect(result).to eq "https://assets.publishing.service.gov.uk/media/673601dc37aabe56c416117e/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_Certificated_work_November_2024.pdf#page=125"
    end

    it "takes me to a specific part of PDF in the LC Guidance" do
      result = described_class.call(document: :lc_guidance_certificated, sub_section: :mandatory_discretionary_disreguarded_capital)
      expect(result).to eq "https://assets.publishing.service.gov.uk/media/673601dc37aabe56c416117e/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_Certificated_work_November_2024.pdf#page=73"
    end

    it "takes me to the external CW form page" do
      result = described_class.call(document: :laa_cw_forms)
      expect(result).to eq "https://www.gov.uk/government/collections/controlled-work-application-forms"
    end
  end
end
