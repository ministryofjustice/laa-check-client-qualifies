require "rails_helper"

RSpec.describe GuidanceLinkService do
  describe ".call" do
    it "shows controlled LC Guidance links" do
      result = described_class.call(document: :lc_guidance_controlled)
      expect(result).to eq "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1176119/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation__August_2023_.pdf"
    end

    it "shows certificated LC Guidance links" do
      result = described_class.call(document: :lc_guidance_certificated)
      expect(result).to eq "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1176073/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work__August_2023_.pdf"
    end

    it "shows just the page number to the correct LC Guidance, when page_number_only: is true" do
      result = described_class.call(document: :lc_guidance_controlled, sub_section: :disregarded_payments, page_number_only: true)
      expect(result).to eq 15
    end

    it "takes me to a specific part of PDF in the LC Guidance" do
      result = described_class.call(document: :lc_guidance_certificated, sub_section: :upper_tribunal)
      expect(result).to eq "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1176073/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work__August_2023_.pdf#page=110"
    end
  end
end
