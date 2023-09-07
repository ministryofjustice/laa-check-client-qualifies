require "rails_helper"

RSpec.describe "Accessing from another device" do
  let(:cookie_banner_text) { "Cookies on Check if your client qualifies for legal aid" }

  scenario "I visit a page for which I do not have a session" do
    visit result_path("some-arbitrary-assessment-code")
    expect(page).to have_content "You cannot access this page"
  end
end
