require "rails_helper"

RSpec.describe "matter_type", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/matter_type"
  end

  context "when level of help is certificated" do
    it "shows a domestic abuse option" do
      expect(page).to have_content "Domestic abuse"
    end
  end

  context "when level of help is controlled" do
    before do
      set_session(assessment_code, "level_of_help" => "controlled")
      visit "estimates/#{assessment_code}/build_estimates/matter_type"
    end

    it "shows no domestic abuse option" do
      expect(page).not_to have_content "Domestic abuse"
    end
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Select what type of matter this is"
  end

  it "stores the chosen value in the session" do
    choose "Another legal matter"
    click_on "Save and continue"
    expect(session_contents["proceeding_type"]).to eq "SE003"
  end
end
