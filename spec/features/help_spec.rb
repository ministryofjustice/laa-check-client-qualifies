require "rails_helper"

RSpec.describe "Help page", :public_beta_flag do
  scenario "I can view the help page" do
    visit root_path
    click_on "Help"
    expect(page).to have_current_path "/help"
  end
end
