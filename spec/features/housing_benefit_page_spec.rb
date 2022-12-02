require "rails_helper"

RSpec.describe "Housing Benefit Pages" do
  let(:housing_benefit_header) { I18n.t("estimate_flow.housing_benefit.housing_benefit_received.legend") }
  let(:housing_benefit_details_header) { I18n.t("estimate_flow.housing_benefit_details.heading") }
  let(:benefits_page_heading) { I18n.t("estimate_flow.benefits.legend") }
  let(:estimate_id) { SecureRandom.uuid }

  before do
    visit_flow_page(passporting: false, target: :housing_benefit)
  end

  it "shows the correct screen" do
    expect(page).to have_content(housing_benefit_header)
  end

  context "when I omit some required information" do
    before do
      click_on "Save and continue"
    end

    it "shows me an error message" do
      expect(page).to have_content housing_benefit_header
      expect(page).to have_content "Select yes if your client receives Housing Benefit"
    end
  end

  context "when I say 'no' on the first page" do
    before do
      select_boolean_value("housing-benefit-form", :housing_benefit, false)
      click_on "Save and continue"
    end

    it "Moves me on to the other benefits page" do
      expect(page).to have_content benefits_page_heading
    end
  end

  context "when I say 'yes' on the first page" do
    before do
      select_boolean_value("housing-benefit-form", :housing_benefit, true)
      click_on "Save and continue"
    end

    it "shows the correct screen" do
      expect(page).to have_content(housing_benefit_details_header)
    end

    context "when I omit some required information" do
      before do
        click_on "Save and continue"
      end

      it "shows me an error message" do
        expect(page).to have_content housing_benefit_details_header
        expect(page).to have_content "Please enter the value of your client's Housing Benefit"
        expect(page).to have_content "Please select how frequently your client receives Housing Benefit"
      end
    end

    context "when I fill in all required information" do
      before do
        fill_in "housing-benefit-details-form-housing-benefit-value-field", with: 135
        select_radio_value("housing-benefit-details-form", "housing-benefit-frequency", "every_two_weeks")
        click_on("Save and continue")
      end

      it "Moves me on to the other benefits page" do
        expect(page).to have_content benefits_page_heading
      end
    end
  end
end
