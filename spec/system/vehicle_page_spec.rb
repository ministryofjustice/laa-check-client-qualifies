require "rails_helper"

RSpec.describe "Vehicle Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:check_answers_header) { "Check your answers" }
  let(:assets_header) { "Which of these assets does your client have?" }

  before do
    travel_to arbitrary_fixed_time
  end

  describe "CFE submission" do
    before do
      driven_by(:headless_chrome)
      visit_check_answers(passporting: true) do |step|
        case step
        when :vehicle
          select_boolean_value("vehicle-form", :vehicle_owned, true)
          click_on "Save and continue"
          fill_in "client-vehicle-details-form-vehicle-value-field", with: 18_000
          select_boolean_value("client-vehicle-details-form", :vehicle_in_regular_use, true)
          select_boolean_value("client-vehicle-details-form", :vehicle_over_3_years_ago, false)
          select_boolean_value("client-vehicle-details-form", :vehicle_pcp, true)
          fill_in "client-vehicle-details-form-vehicle-finance-field", with: 500
        end
      end
    end

    it "handles a full submit to CFE" do
      click_on "Submit"

      expect(page).to have_content "Your client appears provisionally eligible"
    end
  end
end
