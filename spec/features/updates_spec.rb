require "rails_helper"

RSpec.describe "Updates page" do
  scenario "I can view the updates page" do
    visit root_path
    click_on "Updates"
    expect(page).to have_current_path "/updates"
    expect(page).to have_content "Changes for clients aged under 18"
  end
end
