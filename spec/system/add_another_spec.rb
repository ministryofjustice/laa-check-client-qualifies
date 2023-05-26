require "rails_helper"

RSpec.describe "Add another JS", :household_section_flag do
  let(:assessment_code) { :assessment_code }

  before do
    driven_by(:headless_chrome)
    start_assessment
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Enter the estimated value of the vehicle"
  end

  it "lets me add multiple vehicles" do
    fill_in "1-vehicle-value", with: "123"
    choose "No", name: "vehicle_model[items][1][vehicle_pcp]"
    choose "No", name: "vehicle_model[items][1][vehicle_over_3_years_ago]"
    choose "No", name: "vehicle_model[items][1][vehicle_in_regular_use]"
    click_on "Add another vehicle"

    fill_in "2-vehicle-value", with: "789"
    choose "Yes", name: "vehicle_model[items][2][vehicle_pcp]"
    fill_in "2-vehicle-finance", with: "456"
    choose "Yes", name: "vehicle_model[items][2][vehicle_over_3_years_ago]"
    choose "Yes", name: "vehicle_model[items][2][vehicle_in_regular_use]"
    check "This asset is a subject matter of dispute", id: "2-smod"
    click_on "Save and continue"

    expect(session_contents.dig("vehicles", 0, "vehicle_value")).to eq 123
    expect(session_contents.dig("vehicles", 0, "vehicle_pcp")).to eq false
    expect(session_contents.dig("vehicles", 0, "vehicle_finance")).to eq nil
    expect(session_contents.dig("vehicles", 0, "vehicle_over_3_years_ago")).to eq false
    expect(session_contents.dig("vehicles", 0, "vehicle_in_regular_use")).to eq false
    expect(session_contents.dig("vehicles", 0, "vehicle_in_dispute")).to eq false

    expect(session_contents.dig("vehicles", 1, "vehicle_value")).to eq 789
    expect(session_contents.dig("vehicles", 1, "vehicle_pcp")).to eq true
    expect(session_contents.dig("vehicles", 1, "vehicle_finance")).to eq 456
    expect(session_contents.dig("vehicles", 1, "vehicle_over_3_years_ago")).to eq true
    expect(session_contents.dig("vehicles", 1, "vehicle_in_regular_use")).to eq true
    expect(session_contents.dig("vehicles", 1, "vehicle_in_dispute")).to eq true
  end

  it "lets me remove a vehicle" do
    fill_in "1-vehicle-value", with: "123"
    choose "No", name: "vehicle_model[items][1][vehicle_pcp]"
    choose "No", name: "vehicle_model[items][1][vehicle_over_3_years_ago]"
    choose "No", name: "vehicle_model[items][1][vehicle_in_regular_use]"

    click_on "Add another vehicle"
    fill_in "2-vehicle-value", with: "456"
    choose "No", name: "vehicle_model[items][2][vehicle_pcp]"
    choose "Yes", name: "vehicle_model[items][2][vehicle_over_3_years_ago]"
    choose "Yes", name: "vehicle_model[items][2][vehicle_in_regular_use]"

    click_on "Add another vehicle"
    fill_in "3-vehicle-value", with: "789"
    choose "No", name: "vehicle_model[items][3][vehicle_pcp]"
    choose "No", name: "vehicle_model[items][3][vehicle_over_3_years_ago]"
    choose "No", name: "vehicle_model[items][3][vehicle_in_regular_use]"

    click_on "Save and continue"

    click_on "Back"

    click_on "remove-2"

    click_on "Save and continue"

    expect(session_contents.dig("vehicles", 0, "vehicle_value")).to eq 123
    expect(session_contents.dig("vehicles", 1, "vehicle_value")).to eq 789
  end
end
