require "rails_helper"

RSpec.describe "shared ownership work flow", :shared_ownership, :stub_cfe_calls_with_webmock, type: :feature do
  it "allows me to reach check answers via the shared ownership questions" do
    start_assessment
    fill_in_forms_until(:property)
    fill_in_property_screen(choice: "Yes, through a shared ownership scheme")
    fill_in_housing_shared_who_screen(choice: "Yes")
    confirm_screen(:shared_ownership_housing_costs)
    fill_in_shared_ownership_housing_costs_screen
    fill_in_property_entry_screen
    confirm_screen(:additional_property)
    fill_in_forms_until(:check_answers)
    expect(page).to have_content "Yes, through a shared ownership scheme"
  end
end
