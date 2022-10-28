require "rails_helper"

RSpec.describe "Results Page" do
  let(:estimate_id) { "123" }
  let(:mock_connection) do
    instance_double(CfeConnection, api_result: CalculationResult.new(payload), create_applicant: nil)
  end

  describe "Client income" do
    let(:payload) do
      {
        "success": true,
        "result_summary": {
          "overall_result": {
            "result": "contribution_required",
            "capital_contribution": 2000,
            "income_contribution": 1219.95,
          },
          "disposable_income": {
            "employment_income": {
              "gross_income": 123.56,
            },
          },
        },
        "assessment": {
          "gross_income": {
            "irregular_income": {
              "monthly_equivalents": {
                "student_loan": 123.45,
              },
            },
            "state_benefits": {
              "monthly_equivalents": {
                "all_sources": 123.67,
              },
            },
            "other_income": {
              "monthly_equivalents": {
                "all_sources": {
                  "friends_or_family": 123.78,
                  "maintenance_in": 123.79,
                  "property_or_lodger": 123.80,
                  "pension": 123.81,
                },
              },
            },
          },
        },
      }
    end

    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      allow(mock_connection).to receive(:create_assessment_id)
      allow(mock_connection).to receive(:create_proceeding_type)
      allow(mock_connection).to receive(:create_regular_payments)
      allow(mock_connection).to receive(:create_properties)
      allow(mock_connection).to receive(:create_capitals)

      visit "/estimates/#{estimate_id}/build_estimates/assets"

      fill_in "assets-form-property-value-field", with: "0"
      fill_in "assets-form-savings-field", with: "0"

      fill_in "assets-form-investments-field", with: "4300"
      fill_in "assets-form-valuables-field", with: "2200"

      click_on "Save and continue"
      click_on "Submit"
    end

    context "when eligible" do
      let(:payload) { FactoryBot.build(:api_result, eligible: true) }

      it "show eligible" do
        expect(page).to have_content "Your client appears provisionally eligible for legal aid based on the information provided."
      end
    end

    context "when not eligible" do
      let(:payload) { FactoryBot.build(:api_result, eligible: false) }

      it "show ineligible" do
        expect(page).to have_content("Ineligible")
      end
    end
  end

  describe "Client accordions", :vcr do
    let(:arbitrary_fixed_time) { Time.zone.local(2022, 10, 17, 9, 0, 0) }

    before do
      travel_to arbitrary_fixed_time

      visit_applicant_page
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:dependants, true)
      fill_in "applicant-form-dependant-count-field", with: "1"

      select_applicant_boolean(:employed, true)
      select_applicant_boolean(:passporting, false)
      click_on "Save and continue"

      fill_in "employment-form-gross-income-field", with: 1000
      fill_in "employment-form-income-tax-field", with: 400
      fill_in "employment-form-national-insurance-field", with: 50
      select "Monthly", from: "employment-form-frequency-field"
      click_on "Save and continue"

      select_boolean_value("benefits-form", :add_benefit, false)
      click_on("Save and continue")

      click_checkbox("monthly-income-form-monthly-incomes", "friends_or_family")
      fill_in "monthly-income-form-friends-or-family-field", with: "100"
      click_checkbox("monthly-income-form-monthly-incomes", "maintenance")
      fill_in "monthly-income-form-maintenance-field", with: "200"
      click_checkbox("monthly-income-form-monthly-incomes", "property_or_lodger")
      fill_in "monthly-income-form-property-or-lodger-field", with: "300"
      click_checkbox("monthly-income-form-monthly-incomes", "pension")
      fill_in "monthly-income-form-pension-field", with: "40"
      click_checkbox("monthly-income-form-monthly-incomes", "student_finance")
      fill_in "monthly-income-form-student-finance-field", with: "600"
      click_checkbox("monthly-income-form-monthly-incomes", "other")
      fill_in "monthly-income-form-other-field", with: "500"
      click_on "Save and continue"

      fill_in "outgoings-form-housing-payments-value-field", with: "300"
      find(:css, "#outgoings-form-housing-payments-frequency-monthly-field").click
      fill_in "outgoings-form-childcare-payments-value-field", with: "0"
      fill_in "outgoings-form-legal-aid-payments-value-field", with: "0"
      fill_in "outgoings-form-maintenance-payments-value-field", with: "0"
      click_on "Save and continue"

      click_checkbox("property-form-property-owned", "with_mortgage")
      click_on "Save and continue"

      fill_in "property-entry-form-house-value-field", with: 100_000
      fill_in "property-entry-form-mortgage-field", with: 80_000
      fill_in "property-entry-form-percentage-owned-field", with: 20
      click_on "Save and continue"

      select_boolean_value("vehicle-form", :vehicle_owned, true)
      click_on "Save and continue"
      fill_in "vehicle-details-form-vehicle-value-field", with: 18_000
      select_boolean_value("vehicle-details-form", :vehicle_in_regular_use, true)
      select_boolean_value("vehicle-details-form", :vehicle_over_3_years_ago, false)
      select_boolean_value("vehicle-details-form", :vehicle_pcp, true)
      fill_in "vehicle-details-form-vehicle-finance-field", with: 500
      click_on "Save and continue"

      fill_in "assets-form-property-value-field", with: "80_000"
      fill_in "assets-form-property-mortgage-field", with: "70_000"
      fill_in "assets-form-property-percentage-owned-field", with: "50"

      fill_in "assets-form-savings-field", with: "200"
      fill_in "assets-form-investments-field", with: "400"
      fill_in "assets-form-valuables-field", with: "600"
      click_on "Save and continue"

      click_on "Submit"
    end

    it "shows client income section" do
      within "#income-calculation-content" do
        expect(page).to have_content "Employment income £1,000.00"
        expect(page).to have_content "Benefits received £0.00"
        expect(page).to have_content "Financial help from friends and family £100.00"
        expect(page).to have_content "Maintenance payments from a former partner £200.00"
        expect(page).to have_content "Income from a property or lodger £300.00"
        expect(page).to have_content "Pension £40.00"
        expect(page).to have_content "Student finance £50.00"
        expect(page).to have_content "Other sources £0.00"
        expect(page).to have_content "Total gross monthly income £1,690.00"
        expect(page).to have_content "Total gross income limit £2,657.00"
      end
    end

    it "shows the outgoings section" do
      within "#outgoings-calculation-content" do
        expect(page).to have_content "Housing payments £300.00"
        expect(page).to have_content "Childcare payments £0.00"
        expect(page).to have_content "Maintenance payments to a former partner £0.00"
        expect(page).to have_content "Payments towards legal aid in a criminal case £0.00"
        expect(page).to have_content "Income Tax £400.00"
        expect(page).to have_content "National Insurance £50.00"
        expect(page).to have_content "Employment expenses £45.00"
        expect(page).to have_content "Dependants allowance £307.64"

        expect(page).to have_content "Total gross monthly outgoings £1,102.64"
        expect(page).to have_content "Assessed disposable monthly income £587.36"
        expect(page).to have_content "Disposable monthly income limit £733.00"
      end
    end

    it "shows the capital section" do
      within "#capital-calculation-content" do
        expect(page).to have_content "Property £0.00"
        expect(page).to have_content "Vehicles £2,500.00"
        expect(page).to have_content "Second property £3,800.00"
        expect(page).to have_content "Savings £200.00"
        expect(page).to have_content "Investments £400.00"
        expect(page).to have_content "Valuable items worth £500 or more £600.00"

        expect(page).to have_content "Total capital £7,500.00"
        expect(page).to have_content "Disposable capital limit £8,000.00"
      end
    end
  end
end
