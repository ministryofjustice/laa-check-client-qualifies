require "rails_helper"

RSpec.describe "Instant sessions page" do
  let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }

  before do
    visit root_path # Triggers the session cookie to be set

    allow(CfeConnection).to receive(:assess).and_return(api_response)
  end

  scenario "I request an instant controlled session" do
    visit "instant-controlled"
    expect(page).to have_content "Check your answers"
    expect(page).to have_content "Income before any deductions£1.00"
    expect(page).to have_content "Financial help from friends or family\n£0.00"
    click_on "Submit"
    expect(page).to have_content "Your client is likely to qualify financially for civil legal aid"
  end

  scenario "I request an instant certificated session" do
    visit "instant-certificated"
    expect(page).to have_content "Check your answers"
    expect(page).to have_content "Income before any deductions£1.00"
    expect(page).to have_content "Financial help from friends or family\n£0.00"
    click_on "Submit"
    expect(page).to have_content "Your client is likely to qualify financially for civil legal aid"
  end

  scenario "I typo" do
    expect { visit "instant-typo" }.to raise_error("Unknown session type requested: typo")
  end
end
