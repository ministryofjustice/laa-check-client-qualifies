require "rails_helper"

RSpec.describe "Welcome", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "displays the dummy home page" do
    visit "/"
    expect(page).to have_content "Your application is ready"
  end
end
