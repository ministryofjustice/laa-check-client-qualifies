require "rails_helper"

RSpec.describe "Assets Page" do
  let(:assets_header) { "Which assets does your client have?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id, create_proceeding_type: nil) }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    visit_applicant_page

    select_applicant_boolean(:over_60, false)
    select_applicant_boolean(:dependants, false)
    select_applicant_boolean(:partner, false)
    select_applicant_boolean(:employed, false)
    select_applicant_boolean(:passporting, true)
    click_on "Save and continue"
  end

  context "without main property" do
    before do
      click_checkbox("property-form-property-owned", "none")
      click_on "Save and continue"

      select_boolean_value("vehicle-form", :vehicle_owned, false)
      click_on "Save and continue"
    end

    it "shows the correct page" do
      expect(page).to have_content assets_header
    end

    it "can submit second property" do
      expect(mock_connection)
        .to receive(:create_properties)
             .with(estimate_id, nil, { outstanding_mortgage: 50_000, percentage_owned: 50, value: 100_000 })
      click_checkbox("assets-form-assets", "property")
      fill_in "assets-form-property-value-field", with: "100_000"
      fill_in "assets-form-property-mortgage-field", with: "50_000"
      fill_in "assets-form-property-percentage-owned-field", with: "50"
      click_on "Save and continue"

      expect(page).to have_content "Summary Page"
    end
  end

  context "with a mortgage" do
    before do
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
      click_on "Save and continue"
      expect(page).to have_css(".govuk-error-summary__list")
      within ".govuk-error-summary__list" do
        expect(page).to have_content("Please select at least one option")
      end
    end

    it "can submit second property" do
      expect(mock_connection)
        .to receive(:create_properties)
          .with(estimate_id,
                { outstanding_mortgage: 50_000, percentage_owned: 100, value: 100_000 },
                { outstanding_mortgage: 40_000, percentage_owned: 50, value: 80_000 })

      click_checkbox("assets-form-assets", "property")
      fill_in "assets-form-property-value-field", with: "80_000"
      fill_in "assets-form-property-mortgage-field", with: "40_000"
      fill_in "assets-form-property-percentage-owned-field", with: "50"
      click_on "Save and continue"

      expect(page).to have_content "Summary Page"
    end

    it "can submit non-zero savings and investments" do
      expect(mock_connection)
        .to receive(:create_properties)
              .with(estimate_id,
                    { outstanding_mortgage: 50_000, percentage_owned: 100, value: 100_000 },
                    nil)
      expect(mock_connection).to receive(:create_capitals).with(estimate_id, [100], [500, 1000])
      click_checkbox("assets-form-assets", "savings")
      fill_in "assets-form-savings-field", with: "100"

      click_checkbox("assets-form-assets", "investments")
      fill_in "assets-form-investments-field", with: "500"

      click_checkbox("assets-form-assets", "valuables")
      fill_in "assets-form-valuables-field", with: "1000"

      click_on "Save and continue"

      expect(page).to have_content "Summary Page"
    end

    it "can fill in the assets questions and get to results" do
      allow(mock_connection).to receive(:create_properties)
      allow(mock_connection).to receive(:create_applicant)
      allow(mock_connection).to receive(:api_result).and_return(result_summary: { overall_result: { income_contribution: 12_345.78 } })

      click_checkbox("assets-form-assets", "none")
      click_on "Save and continue"

      expect(page).to have_content "Summary Page"
      click_on "Submit"

      expect(page).to have_content "Your client appears provisionally eligible"
    end
  end
end
