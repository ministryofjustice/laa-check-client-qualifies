require "rails_helper"

RSpec.describe "Accessing from another device" do
  scenario "I visit a page for which I do not have a session" do
    visit result_path("some-arbitrary-assessment-code")
    expect(page).to have_content "You cannot access this page"
    expect(page).to have_content "Give feedback on this page"
  end
end
