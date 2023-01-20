require "rails_helper"

RSpec.describe "Results Page" do
  describe "Client income" do
    let(:estimate_id) { "123" }
    let(:mock_connection) do
      instance_double(CfeConnection, api_result: CalculationResult.new(payload),
                                     create_applicant: nil,
                                     create_assessment_id: nil,
                                     create_proceeding_type: nil,
                                     create_regular_payments: nil,
                                     create_properties: nil,
                                     create_capitals: nil)
    end

    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)

      visit "/estimates/#{estimate_id}/build_estimates/assets"

      fill_in "client-assets-form-property-value-field", with: "0"
      fill_in "client-assets-form-savings-field", with: "0"

      fill_in "client-assets-form-investments-field", with: "4300"
      fill_in "client-assets-form-valuables-field", with: "2200"

      click_on "Save and continue"
      click_on "Submit"
    end

    context "when eligible" do
      let(:payload) { FactoryBot.build(:api_result, eligible: true) }

      it "show eligible" do
        expect(page).to have_content "Your client appears provisionally eligible for legal aid based on the information provided."
      end

      it "zeroes out the negative assessed capital figure" do
        expect(page).to have_content "Disposable capital £0.00"
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

      visit_check_answers(passporting: false) do |step|
        case step
        when :applicant
          select_radio_value("applicant-form", "proceeding-type", "se003") # non-domestic abuse case
          select_applicant_boolean(:over_60, false)
          select_applicant_boolean(:employed, true)
          select_applicant_boolean(:passporting, false)
        when :dependants
          select_boolean_value("dependant-details-form", :child_dependants, true)
          select_boolean_value("dependant-details-form", :adult_dependants, true)
          fill_in "dependant-details-form-adult-dependants-count-field", with: "2"
          fill_in "dependant-details-form-child-dependants-count-field", with: "1"
        when :employment
          fill_in "employment-form-gross-income-field", with: 1000
          fill_in "employment-form-income-tax-field", with: 400
          fill_in "employment-form-national-insurance-field", with: 50
          select_radio_value("employment-form", "frequency", "monthly")
        when :housing_benefit
          select_boolean_value("housing-benefit-form", :housing_benefit, true)
          click_on "Save and continue"
          fill_in "housing-benefit-details-form-housing-benefit-value-field", with: 135
          select_radio_value("housing-benefit-details-form", "housing-benefit-frequency", "every_two_weeks")
        when :income
          fill_in "other-income-form-friends-or-family-value-field", with: "100"
          select_radio_value("other-income-form", "friends-or-family-frequency", "monthly")
          fill_in "other-income-form-maintenance-value-field", with: "200"
          select_radio_value("other-income-form", "maintenance-frequency", "monthly")
          fill_in "other-income-form-property-or-lodger-value-field", with: "300"
          select_radio_value("other-income-form", "property-or-lodger-frequency", "monthly")
          fill_in "other-income-form-pension-value-field", with: "40"
          select_radio_value("other-income-form", "pension-frequency", "monthly")
          fill_in "other-income-form-student-finance-value-field", with: "600"
          fill_in "other-income-form-other-value-field", with: "333"
        when :outgoings
          fill_in "outgoings-form-housing-payments-value-field", with: "100"
          fill_in "outgoings-form-childcare-payments-value-field", with: "200"
          fill_in "outgoings-form-legal-aid-payments-value-field", with: "300"
          fill_in "outgoings-form-maintenance-payments-value-field", with: "0"
          select_radio_value("outgoings-form", "housing-payments-frequency", "every-week")
          select_radio_value("outgoings-form", "childcare-payments-frequency", "every-two-weeks")
          select_radio_value("outgoings-form", "legal-aid-payments-frequency", "monthly")
        when :property
          select_radio_value("property-form", "property-owned", "with_mortgage")
          click_on "Save and continue"

          fill_in "client-property-entry-form-house-value-field", with: 100_000
          fill_in "client-property-entry-form-mortgage-field", with: 80_000
          fill_in "client-property-entry-form-percentage-owned-field", with: 20
        when :vehicle
          select_boolean_value("vehicle-form", :vehicle_owned, true)
          click_on "Save and continue"
          fill_in "client-vehicle-details-form-vehicle-value-field", with: 18_000
          select_boolean_value("client-vehicle-details-form", :vehicle_in_regular_use, true)
          select_boolean_value("client-vehicle-details-form", :vehicle_over_3_years_ago, false)
          select_boolean_value("client-vehicle-details-form", :vehicle_pcp, true)
          fill_in "client-vehicle-details-form-vehicle-finance-field", with: 500
        when :assets
          fill_in "client-assets-form-property-value-field", with: "80,000"
          fill_in "client-assets-form-property-mortgage-field", with: "70000"
          fill_in "client-assets-form-property-percentage-owned-field", with: "50"

          fill_in "client-assets-form-savings-field", with: "200"
          fill_in "client-assets-form-investments-field", with: "400"
          fill_in "client-assets-form-valuables-field", with: "600"
        end
      end
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
        expect(page).to have_content "Other sources £111.00"
        expect(page).to have_content "Total gross monthly income £1,801.00"
        expect(page).to have_content "Total gross income upper limit £2,657.00"
      end
    end

    it "shows the outgoings section" do
      within "#outgoings-calculation-content" do
        expect(page).to have_content "Housing payments £140.83"
        expect(page).to have_content "Childcare payments £433.33"
        expect(page).to have_content "Maintenance payments to a former partner £0.00"
        expect(page).to have_content "Payments towards legal aid in a criminal case £300.00"
        expect(page).to have_content "Income tax £400.00"
        expect(page).to have_content "National Insurance £50.00"
        expect(page).to have_content "Employment expenses £45.00"
        expect(page).to have_content "Dependants allowance £922.92"

        expect(page).to have_content "Total gross monthly outgoings £2,292.08"
        expect(page).to have_content "Assessed disposable monthly income -£491.08"
        expect(page).to have_content "Disposable monthly income upper limit £733.00"
      end
    end

    it "shows the capital section" do
      within "#capital-calculation-content" do
        expect(page).to have_content "Property Value £"
        expect(page).to have_content "Outstanding mortgage -£70,000.00"
        expect(page).to have_content "Disregards and deductions -£100,000.00"
        expect(page).to have_content "Assessed value £"
        expect(page).to have_content "Vehicles Value £"
        expect(page).to have_content "Outstanding payments -£500.00"
        expect(page).to have_content "Assessed value £"
        expect(page).to have_content "Additional property Value £"
        expect(page).to have_content "Savings £"
        expect(page).to have_content "Investments and valuables £"
        expect(page).to have_content "Total capital £"
      end
    end
  end

  describe "Partner sections accordions", :vcr, :partner_flag do
    let(:arbitrary_fixed_time) { Time.zone.local(2022, 10, 17, 9, 0, 0) }

    before do
      travel_to arbitrary_fixed_time

      visit_check_answers(passporting: false, partner: true) do |step|
        case step
        when :partner_details
          select_boolean_value("partner-details-form", :over_60, false)
          select_boolean_value("partner-details-form", :employed, true)
        when :partner_employment
          fill_in "partner-employment-form-gross-income-field", with: 1000
          fill_in "partner-employment-form-income-tax-field", with: 400
          fill_in "partner-employment-form-national-insurance-field", with: 50
          select_radio_value("partner-employment-form", "frequency", "monthly")
        when :partner_housing_benefit
          select_boolean_value("partner-housing-benefit-form", :housing_benefit, true)
          click_on("Save and continue")
          fill_in "partner-housing-benefit-details-form-housing-benefit-value-field", with: 135
          select_radio_value("partner-housing-benefit-details-form", "housing-benefit-frequency", "every_two_weeks")
        when :partner_income
          fill_in "partner-other-income-form-friends-or-family-value-field", with: "100"
          select_radio_value("partner-other-income-form", "friends-or-family-frequency", "monthly")
          fill_in "partner-other-income-form-maintenance-value-field", with: "200"
          select_radio_value("partner-other-income-form", "maintenance-frequency", "monthly")
          fill_in "partner-other-income-form-property-or-lodger-value-field", with: "300"
          select_radio_value("partner-other-income-form", "property-or-lodger-frequency", "monthly")
          fill_in "partner-other-income-form-pension-value-field", with: "40"
          select_radio_value("partner-other-income-form", "pension-frequency", "monthly")
          fill_in "partner-other-income-form-student-finance-value-field", with: "600"
          fill_in "partner-other-income-form-other-value-field", with: "333"
        when :partner_outgoings
          fill_in "partner-outgoings-form-housing-payments-value-field", with: "300"
          select_radio_value("partner-outgoings-form", "housing-payments-frequency", :monthly)
          fill_in "partner-outgoings-form-childcare-payments-value-field", with: "0"
          fill_in "partner-outgoings-form-legal-aid-payments-value-field", with: "0"
          fill_in "partner-outgoings-form-maintenance-payments-value-field", with: "0"
        when :partner_vehicle
          select_boolean_value("partner-vehicle-form", :vehicle_owned, true)
          click_on "Save and continue"
          fill_in "partner-vehicle-details-form-vehicle-value-field", with: 18_000
          select_boolean_value("partner-vehicle-details-form", :vehicle_in_regular_use, true)
          select_boolean_value("partner-vehicle-details-form", :vehicle_over_3_years_ago, false)
          select_boolean_value("partner-vehicle-details-form", :vehicle_pcp, true)
          fill_in "partner-vehicle-details-form-vehicle-finance-field", with: 500
        when :partner_assets
          fill_in "partner-assets-form-property-value-field", with: "80,000"
          fill_in "partner-assets-form-property-mortgage-field", with: "70,000"
          fill_in "partner-assets-form-property-percentage-owned-field", with: "50"

          fill_in "partner-assets-form-savings-field", with: "200"
          fill_in "partner-assets-form-investments-field", with: "400"
          fill_in "partner-assets-form-valuables-field", with: "600"
        end
      end

      click_on "Submit"
    end

    it "shows client income section" do
      within "#income-calculation-content" do
        expect(page).to have_content "Partner's income Employment income £1,000.00"
        expect(page).to have_content "Total gross monthly income £1,801.00"
      end
    end

    it "shows the outgoings section" do
      within "#outgoings-calculation-content" do
        expect(page).to have_content "Partner's outgoings Housing payments"
      end
    end

    it "shows the capital section" do
      within "#capital-calculation-content" do
        expect(page).to have_content "Partner's additional property Value £80,000.00"
      end
    end
  end
end
