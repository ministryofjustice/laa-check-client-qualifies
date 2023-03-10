require "rails_helper"

RSpec.describe "partner_benefits", type: :feature do
  let(:assessment_code) { :assessment_code }

  context "when no benefits have previously been added" do
    before do
      visit "estimates/#{assessment_code}/build_estimates/partner_benefits"
    end

    it "shows an error message if no value is entered" do
      click_on "Save and continue"
      expect(page).to have_content "Select yes if the partner gets any other benefits"
    end
  end

  context "when a benefit has previously been added" do
    before do
      set_session(assessment_code, "partner_benefits" => [
        {
          "benefit_type" => "BENEFIT A",
          "id" => "BENEFIT_ID",
        },
      ])

      allow(CfeConnection).to receive(:connection).and_return(
        instance_double(CfeConnection, state_benefit_types: []),
      )
      visit "estimates/#{assessment_code}/build_estimates/partner_benefits"
    end

    it "lets me remove a previously entered benefit" do
      click_on "Remove"
      expect(session_contents["partner_benefits"]).to be_blank
    end
  end
end
