require "rails_helper"

RSpec.describe "Property Page" do
  let(:check_answers_header) { "Check your answers" }
  let(:property_entry_header) { "How much is your client's home worth?" }
  let(:partner_property_entry_header) { "How much is the home worth?" }
  let(:property_header) { "Does your client own the home they live in?" }
  let(:vehicle_header) { "Does your client own a vehicle?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, api_result: CalculationResult.new(build(:api_result)), create_assessment_id: estimate_id) }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    allow(mock_connection).to receive(:create_proceeding_type)
    allow(mock_connection).to receive(:create_regular_payments)
    allow(mock_connection).to receive(:create_applicant)
    visit_applicant_page
  end

  context "with partner", :partner_flag do
    let(:partner) { true }
    let(:expected_main_home) do
      { outstanding_mortgage: mortgage,
        percentage_owned: expected_share,
        shared_with_housing_assoc: false,
        value: 100_000 }
    end

    before do
      fill_in_applicant_screen_with_passporting_benefits
      click_on "Save and continue"
      allow(mock_connection).to receive(:create_partner)
    end

    context "without main client dwelling" do
      before do
        skip_property_form
        skip_vehicle_form
        skip_assets_form
        select_boolean_value("partner-details-form", :over_60, false)
        select_boolean_value("partner-details-form", :employed, false)
        click_on "Save and continue"
        skip_partner_dependants_form
      end

      context "without dwelling" do
        it "doesn't send a main dwelling" do
          skip_partner_property_form
          skip_partner_vehicle_form
          skip_assets_form(subject: :partner)

          click_on "Submit"
        end
      end

      context "when partner owns main dwelling" do
        before do
          click_checkbox("partner-property-form-property-owned", property_ownership)
          click_on "Save and continue"
          fill_in "partner-property-entry-form-house-value-field", with: 100_000
          fill_in "partner-property-entry-form-percentage-owned-field", with: 40
        end

        context "with mortgage" do
          let(:property_ownership) { "with_mortgage" }
          let(:expected_share) { 40 }
          let(:mortgage) { 50_000 }

          context "without a value" do
            it "errors" do
              click_on "Save and continue"
              within ".govuk-error-summary__list" do
                expect(page).to have_content("Please enter the the outstanding mortgage amount your client's partner has")
              end
            end
          end

          context "with a value" do
            before do
              fill_in "partner-property-entry-form-mortgage-field", with: mortgage
              click_on "Save and continue"
              skip_partner_vehicle_form
              skip_assets_form(subject: :partner)
            end

            it "submits the partner asset as the main home" do
              expect(mock_connection)
                .to receive(:create_properties)
                      .with(estimate_id,
                            { main_home: expected_main_home })
              click_on "Submit"
            end

            it "can do a check answers loop, changing mortgage to N/A" do
              within "#subsection-partner_property-header" do
                click_on "Change"
              end
              select_radio_value("partner-property-form", "property-owned", "outright")
              click_on "Save and continue"
              click_on "Save and continue"
              within "#field-list-partner_property" do
                expect(find("#outstanding-mortgage")).to have_content("Outstanding mortgageNot applicable")
              end
            end
          end
        end

        context "without mortgage" do
          let(:property_ownership) { "outright" }
          let(:expected_share) { 40 }
          let(:mortgage) { 0 }

          it "submits the partner asset as the main home" do
            click_on "Save and continue"
            expect(mock_connection)
              .to receive(:create_properties)
                    .with(estimate_id,
                          { main_home: expected_main_home })

            skip_partner_vehicle_form
            skip_assets_form(subject: :partner)

            click_on "Submit"
          end
        end
      end
    end

    context "when client owns main dwelling" do
      let(:mortgage) { 50_000 }

      before do
        click_checkbox("property-form-property-owned", "with_mortgage")
        click_on "Save and continue"
        fill_in "client-property-entry-form-house-value-field", with: 100_000
        fill_in "client-property-entry-form-mortgage-field", with: mortgage
        fill_in "client-property-entry-form-percentage-owned-field", with: 50
      end

      context "without shared ownership" do
        let(:expected_share) { 50 }

        it "submits 50% share" do
          expect(mock_connection)
            .to receive(:create_properties)
                  .with(estimate_id,
                        { main_home: expected_main_home })
          choose("No")
          click_on "Save and continue"
          complete_from_vehicle_form
        end
      end

      context "without a partner percentage" do
        it "errors" do
          choose("Yes")
          click_on "Save and continue"
          within ".govuk-error-summary__list" do
            expect(page).to have_content("Please specify what percentage of the house the partner owns")
          end
        end
      end

      context "when percentage exceeded 100" do
        it "errors" do
          choose("Yes")
          fill_in "client-property-entry-form-joint-percentage-owned-field", with: 51
          click_on "Save and continue"
          within ".govuk-error-summary__list" do
            expect(page).to have_content("Total property share cannot exceed 100%")
          end
        end
      end

      context "with shared ownership" do
        let(:expected_share) { 70 }

        it "submits 70% share" do
          expect(mock_connection)
            .to receive(:create_properties)
                  .with(estimate_id,
                        { main_home: expected_main_home })
          choose("Yes")
          fill_in "client-property-entry-form-joint-percentage-owned-field", with: 20
          click_on "Save and continue"
          complete_from_vehicle_form
        end
      end
    end

    def complete_from_vehicle_form
      skip_vehicle_form
      skip_assets_form
      select_boolean_value("partner-details-form", :over_60, false)
      select_boolean_value("partner-details-form", :employed, false)
      click_on "Save and continue"
      skip_partner_dependants_form
      skip_partner_vehicle_form
      skip_assets_form(subject: :partner)

      click_on "Submit"
    end
  end

  context "without partner" do
    let(:partner) { false }

    before do
      fill_in_applicant_screen_with_passporting_benefits
      click_on "Save and continue"
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
          fill_in "client-property-entry-form-house-value-field", with: 100_000
          fill_in "client-property-entry-form-mortgage-field", with: 50_000
          fill_in "client-property-entry-form-percentage-owned-field", with: 37
        end

        it "can be changed via check answers" do
          click_checkbox("client-property-entry-form-house-in-dispute", "true")
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
          allow(mock_connection).to receive(:api_result).and_return(CalculationResult.new(build(:api_result)))
          expect(mock_connection)
            .to receive(:create_properties)
                  .with(estimate_id, { main_home: { outstanding_mortgage: 50_000,
                                                    percentage_owned: 37,
                                                    value: 100_000,
                                                    shared_with_housing_assoc: false,
                                                    subject_matter_of_dispute: true } })

          click_checkbox("client-property-entry-form-house-in-dispute", "true")

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
          expect(page).to have_content I18n.t("activemodel.errors.models.client_property_entry_form.attributes.house_value.blank")
          expect(page).to have_content I18n.t("activemodel.errors.models.client_property_entry_form.attributes.mortgage.blank")
          expect(page).to have_content I18n.t("activemodel.errors.models.client_property_entry_form.attributes.percentage_owned.blank")
        end
      end
    end
  end
end
