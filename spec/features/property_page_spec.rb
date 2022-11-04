require "rails_helper"

RSpec.describe "Property Page" do
  let(:check_answers_header) { "Check your answers" }
  let(:property_entry_header) { "How much is your client's home worth?" }
  let(:property_header) { "Does your client own the home they live in?" }
  let(:vehicle_header) { "Does your client own a vehicle?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    allow(mock_connection).to receive(:create_proceeding_type)
    allow(mock_connection).to receive(:create_regular_payments)
    allow(mock_connection).to receive(:create_applicant)
    visit estimate_build_estimate_path estimate_id, :property
  end

  it "shows the correct form" do
    expect(page).to have_content property_header
  end

  it "sets error on property form" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Please select the option that best describes your client's property ownership")
    end
  end

  context "with a mortgage" do
    before do
      select_radio_value("property-form", "property-owned", "with_mortgage")
      click_on "Save and continue"
    end

    it "shows the property entry screen" do
      expect(page).to have_content property_entry_header
    end

    context "with a property" do
      before do
        fill_in "property-entry-form-house-value-field", with: 100_000
        fill_in "property-entry-form-mortgage-field", with: 50_000
        fill_in "property-entry-form-percentage-owned-field", with: 37
      end

      it "can be changed via check answers" do
        click_checkbox("property-entry-form-house-in-dispute", "true")
        click_on "Save and continue"
        expect(page).to have_content vehicle_header

        skip_vehicle_form
        skip_assets_form

        within("#subsection-property-header") { click_on "Change" }
        select_radio_value("property-form", "property-owned", "none")
        click_on "Save and continue"
        expect(page).to have_content check_answers_header
        within "#field-list-property" do
          expect(page).not_to have_content "Disputed asset"
          expect(page).not_to have_content "Estimated value"
        end
      end

      it "creates a single property in dispute" do
        allow(mock_connection).to receive(:api_result).and_return(CalculationResult.new({}))
        expect(mock_connection)
          .to receive(:create_properties)
                .with(estimate_id, { main_home: { outstanding_mortgage: 50_000,
                                                  percentage_owned: 37,
                                                  value: 100_000,
                                                  shared_with_housing_assoc: false,
                                                  subject_matter_of_dispute: true } })

        click_checkbox("property-entry-form-house-in-dispute", "true")

        click_on "Save and continue"
        expect(page).to have_content vehicle_header

        select_boolean_value("vehicle-form", :vehicle_owned, false)
        click_on "Save and continue"
        skip_assets_form

        expect(page).to have_content check_answers_header
        within "#field-list-property" do
          expect(page).to have_content "Disputed asset"
        end

        click_on "Submit"
      end
    end

    it "applies validation on the property entry form" do
      click_on "Save and continue"
      within ".govuk-error-summary__list" do
        expect(page).to have_content I18n.t("activemodel.errors.models.property_entry_form.attributes.house_value.blank")
        expect(page).to have_content I18n.t("activemodel.errors.models.property_entry_form.attributes.mortgage.blank")
        expect(page).to have_content I18n.t("activemodel.errors.models.property_entry_form.attributes.percentage_owned.blank")
      end
    end
  end
end
