require "rails_helper"

RSpec.describe "Help page" do
  scenario "I can view the help page" do
    visit root_path
    click_on "Help"
    expect(page).to have_current_path "/help"
  end
end
