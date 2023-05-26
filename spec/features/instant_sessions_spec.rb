require "rails_helper"

RSpec.describe "Instant sessions page" do
  before do
    visit root_path
    visit "instant-controlled" # Trigger the session cookie to be set
  end

  scenario "I request an instant controlled session" do
    visit "instant-controlled"
    expect(page).to have_content "Check your answers"
    expect(page).to have_content "Financial help\n£0.00"
  end

  scenario "I request an instant certificated session" do
    visit "instant-certificated"
    expect(page).to have_content "Check your answers"
    expect(page).to have_content "Financial help\n£0.00"
  end

  scenario "I typo" do
    expect { visit "instant-typo" }.to raise_error("Unknown session type requested: typo")
  end
end
