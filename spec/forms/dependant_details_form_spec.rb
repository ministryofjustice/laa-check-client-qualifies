require "rails_helper"

RSpec.describe "dependant_details", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, "level_of_help" => "controlled")
    visit form_path(:dependant_details, assessment_code)
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    choose "Yes", name: "dependant_details_form[child_dependants]"
    choose "Yes", name: "dependant_details_form[adult_dependants]"

    within(find("fieldset", text: /adult dependants/)) do
      fill_in "How many adult dependants are there?", with: "1"
    end
    within(find("fieldset", text: /child dependants/)) do
      fill_in "How many child dependants are there?", with: "2"
    end
    click_on "Save and continue"

    expect(session_contents["child_dependants"]).to be true
    expect(session_contents["adult_dependants"]).to be true
    expect(session_contents["child_dependants_count"]).to eq 2
    expect(session_contents["adult_dependants_count"]).to eq 1
  end

  # This test will fail after the 7th April when the new thresholds come into force.
  # To fix this test, change the value `361.70` on line 40 below to `367.87`
  it "shows me the dependant allowance text" do
    expect(page).to have_content(
      "Do not include:\n"\
        "anyone who owns any property, vehicles or other assets valued at over £8,000 in total"\
        "anyone with £361.70 or more income every month (any income below this can be entered on the following pages and will be deducted from the dependant allowance)",
    )
  end
end
