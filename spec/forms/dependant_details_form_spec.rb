require "rails_helper"

RSpec.describe "dependant_details", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/dependant_details"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    choose "Yes", name: "dependant_details_form[child_dependants]"
    choose "Yes", name: "dependant_details_form[adult_dependants]"

    within(find("fieldset", text: /adult dependants/)) do
      fill_in "How many?", with: "1"
    end
    within(find("fieldset", text: /child dependants/)) do
      fill_in "How many?", with: "2"
    end
    click_on "Save and continue"

    expect(session_contents["child_dependants"]).to eq true
    expect(session_contents["adult_dependants"]).to eq true
    expect(session_contents["child_dependants_count"]).to eq 2
    expect(session_contents["adult_dependants_count"]).to eq 1
  end

  context "when it is before the 10th of April" do
    before do
      travel_to "2023-04-09"
      visit "estimates/#{assessment_code}/build_estimates/dependant_details"
    end
  
    it "shows me the old dependant allowance text" do
      expect(page).to have_content "anyone with over £307.64 income every month"
    end
  end

  context "when it is after midnight after the 10th of April" do
    before do
      travel_to "2023-04-10"
      visit "estimates/#{assessment_code}/build_estimates/dependant_details"
    end
  
    it "shows me the new dependant allowance text" do
      expect(page).to have_content "anyone with over £338.90 income every month"
    end
  end

end
