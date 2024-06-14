require "rails_helper"

RSpec.describe "benefits", type: :feature do
  before do
    start_assessment
    fill_in_forms_until(:benefits)
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Select yes if your client gets any benefits"
  end
end
