require "rails_helper"

RSpec.describe "benefits", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, "level_of_help" => "controlled")
    visit form_path(:benefits, assessment_code)
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Select yes if your client gets any benefits"
  end
end
