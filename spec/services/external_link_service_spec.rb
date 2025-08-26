require "rails_helper"

RSpec.describe ExternalLinkService do
  describe ".call" do
    it "shows controlled LC Guidance links" do
      result = described_class.call(document: :lc_guidance_controlled)
      expect(result).to eq "https://assets.publishing.service.gov.uk/media/684ff44229fb1002010c4e6c/LC_s_guidance_on_determining_financial_eligibility__controlled_and_mediation_.pdf"
    end

    it "shows certificated LC Guidance links" do
      result = described_class.call(document: :lc_guidance_certificated)
      expect(result).to eq "https://assets.publishing.service.gov.uk/media/684ff4a09d538361ad2da71b/Lord_Chancellor_s_guide_to_determining_financial_eligibility__Certificated_.pdf"
    end

    it "shows just the page number to the correct LC Guidance, when page_number_only: is true" do
      result = described_class.call(document: :lc_guidance_controlled, sub_section: :disregarded_payments, page_number_only: true)
      expect(result).to eq 15
    end

    it "takes me to a specific part of PDF in the certificated LC Guidance" do
      result = described_class.call(document: :lc_guidance_certificated, sub_section: :upper_tribunal)
      expect(result).to eq "https://assets.publishing.service.gov.uk/media/684ff4a09d538361ad2da71b/Lord_Chancellor_s_guide_to_determining_financial_eligibility__Certificated_.pdf#page=126"
    end

    it "takes me to a specific part of PDF in the LC Guidance" do
      result = described_class.call(document: :lc_guidance_certificated, sub_section: :mandatory_discretionary_disregarded_capital)
      expect(result).to eq "https://assets.publishing.service.gov.uk/media/684ff4a09d538361ad2da71b/Lord_Chancellor_s_guide_to_determining_financial_eligibility__Certificated_.pdf#page=74"
    end

    it "takes me to the external CW form page" do
      result = described_class.call(document: :laa_cw_forms)
      expect(result).to eq "https://www.gov.uk/government/collections/controlled-work-application-forms"
    end
  end
end
