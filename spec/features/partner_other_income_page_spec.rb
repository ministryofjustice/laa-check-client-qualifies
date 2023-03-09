require "rails_helper"

RSpec.describe "Partner other income page", :partner_flag do
  let(:partner_other_income_heading) { I18n.t("estimate_flow.partner_other_income.heading") }

  before do
    visit_flow_page(passporting: false, partner: true, target: :partner_other_income)
  end

  it "shows the correct screen" do
    expect(page).to have_content(partner_other_income_heading)
  end

  context "when I omit some required information" do
    before do
      click_on "Save and continue"
    end

    it "shows me an error message" do
      expect(page).to have_content partner_other_income_heading
      expect(page).to have_content "Enter financial help from friends and family, if this does not apply enter 0"
    end
  end

  context "when I provide all required information" do
    before do
      fill_in "partner-other-income-form-friends-or-family-value-field", with: "100"
      select_radio_value("partner-other-income-form", "friends-or-family-frequency", "monthly")
      fill_in "partner-other-income-form-maintenance-value-field", with: "200"
      select_radio_value("partner-other-income-form", "maintenance-frequency", "monthly")
      fill_in "partner-other-income-form-property-or-lodger-value-field", with: "300"
      select_radio_value("partner-other-income-form", "property-or-lodger-frequency", "monthly")
      fill_in "partner-other-income-form-pension-value-field", with: "400"
      select_radio_value("partner-other-income-form", "pension-frequency", "monthly")
      fill_in "partner-other-income-form-student-finance-value-field", with: "0"
      fill_in "partner-other-income-form-other-value-field", with: "500"
    end

    it "Moves me on to the next question and stores my answers" do
      prev_path = current_path
      click_on "Save and continue"
      expect(page).not_to have_content partner_other_income_heading
      visit prev_path
      expect(find("#partner-other-income-form-friends-or-family-value-field").value).to eq "100"
    end
  end
end
