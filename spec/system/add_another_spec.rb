require "rails_helper"

RSpec.describe "Add another JS" do
  let(:assessment_code) { :assessment_code }

  before do
    driven_by(:headless_chrome)
    start_assessment
  end

  describe "vehicles" do
    before do
      fill_in_forms_until(:vehicle)
      fill_in_vehicle_screen(choice: "Yes")
    end

    it "shows an error message if no value is entered" do
      click_on "Save and continue"
      expect(page).to have_content "Enter the estimated value of the vehicle"
    end

    it "shows numbered error messages if there are more than 1 on the page", :slow do
      fill_in "1-vehicle-value", with: "123"
      choose "No", name: "vehicle_model[items][1][vehicle_pcp]"
      choose "No", name: "vehicle_model[items][1][vehicle_over_3_years_ago]"
      choose "No", name: "vehicle_model[items][1][vehicle_in_regular_use]"
      click_on "Add another vehicle"

      click_on "Save and continue"
      expect(page).to have_content "Enter the estimated value of vehicle 2"
    end

    it "lets me add multiple vehicles", :slow do
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
      check "This asset is a subject matter of dispute", id: "2-vehicle_in_dispute"
      click_on "Save and continue"

      click_on "Back"

      expect(find(id: "1-vehicle-value").value).to eq "123"
      expect(find(id: "1-vehicle-pcp-false", visible: false)).to be_checked
      expect(find(id: "1-vehicle-finance", visible: false).value).to eq ""
      expect(find(id: "1-vehicle-over-3-years-ago-false", visible: false)).to be_checked
      expect(find(id: "1-vehicle-in-regular-use-false", visible: false)).to be_checked
      expect(find(id: "1-vehicle_in_dispute", visible: false)).not_to be_checked

      expect(find(id: "2-vehicle-value").value).to eq "789"
      expect(find(id: "2-vehicle-pcp", visible: false)).to be_checked
      expect(find(id: "2-vehicle-finance", visible: false).value).to eq "456"
      expect(find(id: "2-vehicle-over-3-years-ago", visible: false)).to be_checked
      expect(find(id: "2-vehicle-in-regular-use", visible: false)).to be_checked
      expect(find(id: "2-vehicle_in_dispute", visible: false)).to be_checked
    end

    it "lets me remove a vehicle", :slow do
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

      click_on "Back"

      expect(find(id: "1-vehicle-value").value).to eq "123"
      expect(find(id: "2-vehicle-value").value).to eq "789"
    end

    it "removes error messages pertaining to a removed item", :slow do
      fill_in "1-vehicle-value", with: "123"
      choose "No", name: "vehicle_model[items][1][vehicle_pcp]"
      choose "No", name: "vehicle_model[items][1][vehicle_over_3_years_ago]"
      choose "No", name: "vehicle_model[items][1][vehicle_in_regular_use]"
      click_on "Add another vehicle"

      choose "No", name: "vehicle_model[items][2][vehicle_pcp]"
      choose "No", name: "vehicle_model[items][2][vehicle_over_3_years_ago]"
      choose "No", name: "vehicle_model[items][2][vehicle_in_regular_use]"
      click_on "Save and continue"

      expect(page).to have_content "Enter the estimated value of vehicle 2"
      click_on "remove-2"
      expect(page).not_to have_content "Enter the estimated value of vehicle 2"
    end

    it "rewords error messages pertaining items that come after a removed item", :slow do
      fill_in "1-vehicle-value", with: "123"
      choose "No", name: "vehicle_model[items][1][vehicle_pcp]"
      choose "No", name: "vehicle_model[items][1][vehicle_over_3_years_ago]"
      choose "No", name: "vehicle_model[items][1][vehicle_in_regular_use]"
      click_on "Add another vehicle"

      fill_in "2-vehicle-value", with: "456"
      choose "No", name: "vehicle_model[items][2][vehicle_pcp]"
      choose "No", name: "vehicle_model[items][2][vehicle_over_3_years_ago]"
      choose "No", name: "vehicle_model[items][2][vehicle_in_regular_use]"
      click_on "Add another vehicle"

      choose "No", name: "vehicle_model[items][3][vehicle_pcp]"
      choose "No", name: "vehicle_model[items][3][vehicle_over_3_years_ago]"
      choose "No", name: "vehicle_model[items][3][vehicle_in_regular_use]"
      click_on "Save and continue"

      expect(page).to have_content "Enter the estimated value of vehicle 3"
      click_on "remove-2"
      expect(page).to have_content "Enter the estimated value of vehicle 2"
    end
  end

  describe "additional properties" do
    before do
      fill_in_forms_until(:additional_property)
      fill_in_additional_property_screen(choice: "Yes, owned outright")
    end

    it "applies conditional validation appropriately", :slow do
      fill_in "1-house-value", with: "123"
      fill_in "1-percentage-owned", with: "100"
      click_on "Add another property"
      fill_in "2-house-value", with: "123"
      fill_in "2-percentage-owned", with: "100"
      choose "2-inline-owned-with-mortgage"
      fill_in "2-mortgage", with: "Invalid"
      choose "2-inline-owned-with-mortgage-false"
      click_on "Save and continue"
      expect(page).to have_content "Check your answers" # No validation message is shown because the invalid input is irrelevant
    end
  end
end
