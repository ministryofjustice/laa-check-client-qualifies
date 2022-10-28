require "rails_helper"

RSpec.describe "Vehicle Page" do
  let(:assets_header) { "Which of these assets does your client have?" }
  let(:check_answers_header) { "Check your answers" }

  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) do
    instance_double(
      CfeConnection,
      api_result: CalculationResult.new({}),
      create_assessment_id: estimate_id,
      create_proceeding_type: nil,
      create_applicant: nil,
      create_regular_payments: nil,
    )
  end

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    visit estimate_build_estimate_path estimate_id, :vehicle
  end

  it "sets error on vehicle form" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Select yes if the client owns a vehicle")
    end
  end

  context "with no vehicle" do
    before do
      select_vehicle_value(:vehicle_owned, false)
      click_on "Save and continue"
    end

    it "skips vehicle questions" do
      expect(page).to have_content(assets_header)
    end

    context "when checking answers" do
      let(:vehicle_value) { 20_000 }

      before do
        allow(mock_connection).to receive(:create_capitals)
        skip_assets_form
      end

      it "has expected content" do
        expect(page).to have_content check_answers_header
        within("#field-list-vehicles") do
          expect(page).to have_content "No"
        end
      end

      it "can do a simple loop back to check answers" do
        within("#field-list-vehicles") { click_on "Change" }
        click_on "Save and continue"
        expect(page).to have_content check_answers_header
      end

      it "errors correctly if I decline to give further details of a vehicle" do
        within("#field-list-vehicles") { click_on "Change" }
        select_vehicle_value(:vehicle_owned, true)
        click_on "Save and continue"

        fill_in "vehicle-details-form-vehicle-value-field", with: vehicle_value
        click_on "Save and continue"

        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes if the vehicle is in regular use")
        end
      end

      it "can do a loop changing the vehicle answer" do
        within("#field-list-vehicles") { click_on "Change" }
        select_vehicle_value(:vehicle_owned, true)
        click_on "Save and continue"
        fill_in "vehicle-details-form-vehicle-value-field", with: vehicle_value
        select_boolean_value("vehicle-details-form", :vehicle_in_regular_use, false)
        select_boolean_value("vehicle-details-form", :vehicle_pcp, false)
        select_boolean_value("vehicle-details-form", :vehicle_over_3_years_ago, true)
        click_on "Save and continue"
        expect(page).to have_content check_answers_header

        expect(mock_connection).to receive(:create_vehicle)
        click_on "Submit"
      end
    end
  end

  context "with a vehicle" do
    before do
      select_vehicle_value(:vehicle_owned, true)
      click_on "Save and continue"
    end

    let(:loan_amount) { 2_000 }
    let(:vehicle_value) { 5_000 }

    it "has readable errors" do
      click_on "Save and continue"

      expect(page).to have_css(".govuk-error-summary__list")
      within ".govuk-error-summary__list" do
        expect(page).to have_content("Select yes if the vehicle is in regular use")
        expect(page).to have_content("Please enter the estimated value")
      end
    end

    context "when purchased 3 years ago" do
      it "uses 4 years old" do
        expect(mock_connection).to receive(:create_vehicle)
          .with(estimate_id,
                [
                  {
                    date_of_purchase: 4.years.ago.to_date,
                    in_regular_use: true,
                    loan_amount_outstanding: 2_000,
                    subject_matter_of_dispute: true,
                    value: 5_000,
                  },
                ])

        fill_in "vehicle-details-form-vehicle-value-field", with: vehicle_value
        select_boolean_value("vehicle-details-form", :vehicle_in_regular_use, true)
        select_boolean_value("vehicle-details-form", :vehicle_over_3_years_ago, true)
        select_boolean_value("vehicle-details-form", :vehicle_pcp, true)
        check("This asset is a subject matter of dispute")
        fill_in "vehicle-details-form-vehicle-finance-field", with: loan_amount
        progress_to_submit_from_vehicle_form
      end
    end

    context "when purchased recently" do
      it "uses 2 years old" do
        expect(mock_connection).to receive(:create_vehicle)
          .with(estimate_id,
                [
                  {
                    date_of_purchase: 2.years.ago.to_date,
                    in_regular_use: true,
                    loan_amount_outstanding: 2_000,
                    subject_matter_of_dispute: false,
                    value: 5_000,
                  },
                ])

        fill_in "vehicle-details-form-vehicle-value-field", with: vehicle_value
        select_boolean_value("vehicle-details-form", :vehicle_in_regular_use, true)
        select_boolean_value("vehicle-details-form", :vehicle_over_3_years_ago, false)
        select_boolean_value("vehicle-details-form", :vehicle_pcp, true)
        fill_in "vehicle-details-form-vehicle-finance-field", with: loan_amount
        progress_to_submit_from_vehicle_form
      end
    end
  end

  def select_vehicle_value(field, value)
    select_boolean_value("vehicle-form", field, value)
  end
end
