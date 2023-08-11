require "rails_helper"

RSpec.describe "dependant_income", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, "level_of_help" => "controlled")
    visit "estimates/#{assessment_code}/build_estimates/dependant_income"
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Select yes if any dependants aged 16 or over get income"
  end
end
