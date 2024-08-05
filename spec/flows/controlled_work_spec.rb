require "rails_helper"

RSpec.describe "Controlled work flow", :stub_cfe_calls, type: :feature do
  before do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_with(:controlled)
  end

  it "shows me an immigration or asylum screen instead of a matter type screen" do
    fill_in_immigration_or_asylum_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:partner_assets)
    fill_in_partner_assets_screen
    confirm_screen(:check_answers)
  end

  it "lets me specify immigration or asylum details" do
    fill_in_immigration_or_asylum_screen(choice: "Yes")
    fill_in_immigration_or_asylum_type_screen
    fill_in_asylum_support_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:partner_assets)
    fill_in_partner_assets_screen
    confirm_screen(:check_answers)
  end
end
