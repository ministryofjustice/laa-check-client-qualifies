require "rails_helper"

RSpec.describe "Partner outgoings page" do
  let(:partner_outgoings_heading) { I18n.t("estimate_flow.partner_outgoings.heading") }

  before do
    visit_applicant_page_with_partner
    fill_in_applicant_screen_without_passporting_benefits
    add_applicant_partner_answers
    click_on "Save and continue"
    travel_from_dependants_to_past_client_assets
    select_boolean_value("partner-benefits-form", :add_benefit, false)
    click_on "Save and continue"
    complete_incomes_screen(subject: :partner)
  end

  it "shows the correct screen" do
    expect(page).to have_content(partner_outgoings_heading)
  end

  context "when I omit some required information" do
    before do
      click_on "Save and continue"
    end

    it "shows me an error message" do
      expect(page).to have_content partner_outgoings_heading
      expect(page).to have_content "Please enter a zero if your client's partner "
    end
  end

  context "when I provide all required information" do
    before do
      fill_in "partner-outgoings-form-housing-payments-value-field", with: "100"
      fill_in "partner-outgoings-form-childcare-payments-value-field", with: "200"
      fill_in "partner-outgoings-form-legal-aid-payments-value-field", with: "300"
      fill_in "partner-outgoings-form-maintenance-payments-value-field", with: "0"
      find(:css, "#partner-outgoings-form-housing-payments-frequency-every-week-field").click
      find(:css, "#partner-outgoings-form-childcare-payments-frequency-every-two-weeks-field").click
      find(:css, "#partner-outgoings-form-legal-aid-payments-frequency-monthly-field").click
    end

    it "Moves me on to the next question and stores my answers" do
      prev_path = current_path
      click_on "Save and continue"
      expect(page).not_to have_content partner_outgoings_heading
      visit prev_path
      expect(find("#partner-outgoings-form-legal-aid-payments-value-field").value).to eq "300"
    end
  end
end
