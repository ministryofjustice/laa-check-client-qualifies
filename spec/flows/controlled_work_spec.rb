require "rails_helper"

RSpec.describe "Controlled work flow", type: :feature do
  it "skips the vehicle screens on a controlled work check" do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:partner_assets)
    fill_in_partner_assets_screen
    confirm_screen("property")
  end

  it "shows me an immigration or asylum screen instead of a matter type screen" do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_immigration_or_asylum_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:partner_assets)
    fill_in_partner_assets_screen
    confirm_screen("property")
  end

  it "lets me specify immigration or asylum details" do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_immigration_or_asylum_screen(choice: "Yes")
    fill_in_immigration_or_asylum_type_screen
    fill_in_asylum_support_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:partner_assets)
    fill_in_partner_assets_screen
    confirm_screen("property")
  end
end
