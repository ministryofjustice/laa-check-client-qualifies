require "rails_helper"

RSpec.describe GuidanceLinkService do
  describe ".call" do
    context "when MTR phase 1 is enabled", :mtr_phase_1_feature_flag do
      before { travel_to Date.new(2023, 8, 4) }

      it "shows updated LC Guidance controlled links" do
        result = described_class.call(document: :lc_guidance_controlled, original_link: true)
        expect(result).to eq "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1175062/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation__July_2023_.pdf"
      end

      it "shows updated LC Guidance certificated links" do
        result = described_class.call(document: :lc_guidance_certificated, original_link: true)
        expect(result).to eq "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1175064/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work__July_2023_.pdf"
      end

      it "shows just the page number to the correct LC Guidance, when page_number_only: is true" do
        result = described_class.call(document: :lc_guidance_controlled, sub_section: :disregarded_payments, page_number_only: true)
        expect(result).to eq 15
      end

      it "takes me to a specific part of PDF in the LC Guidance" do
        result = described_class.call(document: :lc_guidance_certificated, sub_section: :upper_tribunal)
        expect(result).to eq "/documents/lc_guidance_certificated?sub_section=upper_tribunal"
      end
    end

    context "when MTR phase 1 is not enabled" do
      it "shows legacy LC Guidance controlled links" do
        result = described_class.call(document: :lc_guidance_controlled, original_link: true)
        expect(result).to eq "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1175062/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation__July_2023_.pdf"
      end

      it "shows legacy LC Guidance certificated links" do
        result = described_class.call(document: :lc_guidance_certificated, original_link: true)
        expect(result).to eq "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1175064/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work__July_2023_.pdf"
      end
    end
  end
end
