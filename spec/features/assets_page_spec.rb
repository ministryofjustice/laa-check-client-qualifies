require "rails_helper"

RSpec.describe "Assets Page" do
  let(:assets_header) { "Which of these assets does your client have?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id, create_proceeding_type: nil) }
  let(:check_answers_header) { "Check your answers" }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    allow(mock_connection).to receive(:create_regular_payments)
    allow(mock_connection).to receive(:create_applicant)
    allow(mock_connection).to receive(:api_result).and_return(calculation_result)
  end

  context "without main property" do
    let(:calculation_result) do
      CalculationResult.new(FactoryBot.build(:api_result))
    end

    before do
      visit estimate_build_estimate_path estimate_id, :assets
    end

    it "shows the correct page" do
      expect(page).to have_content assets_header
    end

    it "can submit second property" do
      fill_in "assets-form-savings-field", with: "0"
      fill_in "assets-form-investments-field", with: "0"
      fill_in "assets-form-valuables-field", with: "0"

      expect(mock_connection)
        .to receive(:create_properties)
              .with(estimate_id,
                    main_home: { outstanding_mortgage: 0, value: 0, percentage_owned: 0, shared_with_housing_assoc: false },
                    additional_properties: [
                      { outstanding_mortgage: 50_000,
                        percentage_owned: 50,
                        value: 100_000,
                        shared_with_housing_assoc: false,
                        subject_matter_of_dispute: true },
                    ])
      fill_in "assets-form-property-value-field", with: "100_000"
      fill_in "assets-form-property-mortgage-field", with: "50_000"
      fill_in "assets-form-property-percentage-owned-field", with: "50"
      click_checkbox("assets-form-in-dispute", "property")

      click_on "Save and continue"

      expect(page).to have_content check_answers_header
      click_on "Submit"
    end
  end

  context "with a mortgage on main property" do
    let(:calculation_result) do
      CalculationResult.new(FactoryBot.build(:api_result))
    end

    before do
      visit estimate_build_estimate_path estimate_id, :property
      click_checkbox("property-form-property-owned", "with_mortgage")
      click_on "Save and continue"

      fill_in "property-entry-form-house-value-field", with: 100_000
      fill_in "property-entry-form-mortgage-field", with: 50_000
      fill_in "property-entry-form-percentage-owned-field", with: 100
      click_on "Save and continue"
      select_boolean_value("vehicle-form", :vehicle_owned, false)
      click_on "Save and continue"
    end

    it "shows the correct page" do
      expect(page).to have_content assets_header
    end

    it "sets error on assets form" do
      fill_in "assets-form-savings-field", with: "0"
      fill_in "assets-form-investments-field", with: "0"
      fill_in "assets-form-valuables-field", with: "0"

      click_on "Save and continue"
      expect(page).to have_css(".govuk-error-summary__list")
      within ".govuk-error-summary__list" do
        expect(page).to have_content("Please enter the value of the property")
      end
    end

    it "can submit second property" do
      fill_in "assets-form-savings-field", with: "0"
      fill_in "assets-form-investments-field", with: "0"
      fill_in "assets-form-valuables-field", with: "0"
      expect(mock_connection)
        .to receive(:create_properties)
              .with(estimate_id, main_home:
                    { outstanding_mortgage: 50_000, percentage_owned: 100, value: 100_000, shared_with_housing_assoc: false },
                                 additional_properties: [
                                   { outstanding_mortgage: 40_000, percentage_owned: 50, value: 80_000, shared_with_housing_assoc: false },
                                 ])
      fill_in "assets-form-property-value-field", with: "80_000"
      fill_in "assets-form-property-mortgage-field", with: "40_000"
      fill_in "assets-form-property-percentage-owned-field", with: "50"
      click_on "Save and continue"

      expect(page).to have_content check_answers_header
      expect(page).to have_content "Second property or holiday home: % owned"
      click_on "Submit"
    end

    it "can submit non-zero savings and investments" do
      fill_in "assets-form-property-value-field", with: "0"

      expect(mock_connection)
        .to receive(:create_properties)
              .with(estimate_id,
                    main_home: { outstanding_mortgage: 50_000, percentage_owned: 100, value: 100_000, shared_with_housing_assoc: false })
      expect(mock_connection).to receive(:create_capitals).with(estimate_id, [100], [500, 1000])

      fill_in "assets-form-savings-field", with: "100"
      fill_in "assets-form-investments-field", with: "500"
      fill_in "assets-form-valuables-field", with: "1000"

      click_on "Save and continue"

      expect(page).to have_content check_answers_header
      click_on "Submit"
    end

    it "can skip the assets questions and get to results" do
      allow(mock_connection).to receive(:create_properties)
      allow(mock_connection).to receive(:create_applicant)
      allow(mock_connection).to receive(:create_regular_payments)
      allow(mock_connection).to receive(:api_result).and_return(calculation_result)

      skip_assets_form
      expect(page).to have_content check_answers_header
      click_on "Submit"

      expect(page).to have_content "provisional declaration"
    end
  end

  context "with no mortgage on main property" do
    let(:calculation_result) do
      CalculationResult.new(result_summary: { overall_result: { result: "contribution_required", income_contribution: 12_345.78 } })
    end

    before do
      visit estimate_build_estimate_path estimate_id, :property
      click_checkbox("property-form-property-owned", "outright")
      click_on "Save and continue"

      fill_in "property-entry-form-house-value-field", with: 100_000
      fill_in "property-entry-form-percentage-owned-field", with: 100
      click_on "Save and continue"
      select_boolean_value("vehicle-form", :vehicle_owned, false)
      click_on "Save and continue"
    end

    it "shows the correct page" do
      expect(page).to have_content assets_header
    end

    it "can submit second property" do
      fill_in "assets-form-savings-field", with: "0"
      fill_in "assets-form-investments-field", with: "0"
      fill_in "assets-form-valuables-field", with: "0"

      allow(mock_connection).to receive(:create_regular_payments)
      allow(mock_connection).to receive(:create_applicant)
      allow(mock_connection).to receive(:api_result).and_return(calculation_result)
      expect(mock_connection)
        .to receive(:create_properties)
          .with(estimate_id,
                main_home: { outstanding_mortgage: 0, percentage_owned: 100, value: 100_000, shared_with_housing_assoc: false },
                additional_properties: [{ outstanding_mortgage: 40_000, percentage_owned: 50, value: 80_000, shared_with_housing_assoc: false }])

      fill_in "assets-form-property-value-field", with: "80_000"
      fill_in "assets-form-property-mortgage-field", with: "40_000"
      fill_in "assets-form-property-percentage-owned-field", with: "50"
      click_on "Save and continue"

      expect(page).to have_content check_answers_header
      click_on "Submit"
    end
  end
end
