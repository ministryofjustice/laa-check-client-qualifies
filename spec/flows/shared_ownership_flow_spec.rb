require "rails_helper"

RSpec.describe "shared ownership work flow", :stub_cfe_calls_with_webmock, type: :feature do
  before do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_with(:controlled)
  end

  it "shows me an immigration or asylum screen instead of a matter type screen" do
    start_assessment
    fill_in_forms_until(:property)
    fill_in_property_screen(choice: "Yes, through a shared ownership scheme")
    fill_in_housing_shared_who_screen(choice: "Yes")
    confirm_screen(:shared_ownership_housing_costs)
    fill_in_shared_ownership_housing_costs_screen
    fill_in_property_entry_screen
    #  just gets stuck in a property_entry loop
    confirm_screen(:additional_property)
    fill_in_forms_until(:check_answers)
    expect(page).to have_content "Yes, through a shared ownership scheme"
  end
end
