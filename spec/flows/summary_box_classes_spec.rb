require "rails_helper"

RSpec.describe "Ineligible result, on result screen", :vcr, type: :feature do
  it "displays 3 ineligible summary boxes" do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_forms_until(:other_income)
    fill_in_other_income_screen(values: { friends_or_family: "3000" }, frequencies: { friends_or_family: "Every month" })
    fill_in_forms_until(:assets)
    fill_in_assets_screen(values: { investments: "3000000" })
    fill_in_forms_until(:check_answers)
    click_on "Submit"
    boxes = all(".summary-box").map { _1["class"] }
    css = ["summary-box summary-box-ineligible"] * 3
    expect(boxes).to eq(css)
  end
end
