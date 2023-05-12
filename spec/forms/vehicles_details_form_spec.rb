require "rails_helper"

RSpec.describe "vehicles_details", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/vehicles_details"
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Enter the estimated value of the vehicle"
  end

  it "saves what I enter to the session" do
    fill_in "1-vehicle-value", with: "123"
    choose "Yes", name: "vehicle_model[items][1][vehicle_pcp]"
    fill_in "1-vehicle-finance", with: "456"
    choose "Yes", name: "vehicle_model[items][1][vehicle_over_3_years_ago]"
    choose "Yes", name: "vehicle_model[items][1][vehicle_in_regular_use]"
    check "This asset is a subject matter of dispute", id: "1-smod"
    click_on "Save and continue"
    expect(session_contents.dig("vehicles", 0, "vehicle_value")).to eq 123
    expect(session_contents.dig("vehicles", 0, "vehicle_pcp")).to eq true
    expect(session_contents.dig("vehicles", 0, "vehicle_finance")).to eq 456
    expect(session_contents.dig("vehicles", 0, "vehicle_over_3_years_ago")).to eq true
    expect(session_contents.dig("vehicles", 0, "vehicle_in_regular_use")).to eq true
    expect(session_contents.dig("vehicles", 0, "vehicle_in_dispute")).to eq true
  end
end
