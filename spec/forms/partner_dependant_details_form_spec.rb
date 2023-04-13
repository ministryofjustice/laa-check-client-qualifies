require "rails_helper"

RSpec.describe "partner_dependant_details", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, "level_of_help" => "controlled")
    visit "estimates/#{assessment_code}/build_estimates/partner_dependant_details"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    choose "Yes", name: "partner_dependant_details_form[child_dependants]"
    choose "Yes", name: "partner_dependant_details_form[adult_dependants]"

    within(find("fieldset", text: /adult dependants/)) do
      fill_in "How many?", with: "1"
    end
    within(find("fieldset", text: /child dependants/)) do
      fill_in "How many?", with: "2"
    end
    click_on "Save and continue"

    expect(session_contents["partner_child_dependants"]).to eq true
    expect(session_contents["partner_adult_dependants"]).to eq true
    expect(session_contents["partner_child_dependants_count"]).to eq 2
    expect(session_contents["partner_adult_dependants_count"]).to eq 1
  end
end
