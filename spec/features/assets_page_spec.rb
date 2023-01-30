require "rails_helper"

RSpec.describe "Assets Page" do
  let(:assets_header) { I18n.t("estimate_flow.assets.legend") }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) do
    instance_double(CfeConnection,
                    create_assessment_id: estimate_id,
                    api_result: CalculationResult.new(FactoryBot.build(:api_result)),
                    create_proceeding_type: nil,
                    create_regular_payments: nil,
                    create_applicant: nil)
  end
  let(:check_answers_header) { "Check your answers" }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
  end

  context "without main property" do
    context "with disputed second property" do
      before do
        visit_check_answers(passporting: true) do |step|
          case step
          when :assets
            fill_in "client-assets-form-savings-field", with: "0"
            fill_in "client-assets-form-investments-field", with: "0"
            fill_in "client-assets-form-valuables-field", with: "0"

            fill_in "client-assets-form-property-value-field", with: "100,000"
            fill_in "client-assets-form-property-mortgage-field", with: "50,000"
            fill_in "client-assets-form-property-percentage-owned-field", with: "50"
            click_checkbox("client-assets-form-in-dispute", "property")
          end
        end
      end

      it "can edit via check answers with checked dispute value" do
        within "#subsection-other-header" do
          click_on "Change"
        end
        expect(find("#client-assets-form-in-dispute-property-field")).to be_checked
      end

      it "can submit with an empty first property" do
        expect(mock_connection)
          .to receive(:create_properties)
                .with(estimate_id,
                      {
                        main_home: { outstanding_mortgage: 0, value: 0, percentage_owned: 0, shared_with_housing_assoc: false },
                        additional_properties: [
                          { outstanding_mortgage: 50_000,
                            percentage_owned: 50,
                            value: 100_000,
                            shared_with_housing_assoc: false,
                            subject_matter_of_dispute: true },
                        ],
                      })
        expect(page).to have_content check_answers_header
        within "#field-list-other" do
          expect(page).to have_content "Disputed asset"
        end
        click_on "Submit"
      end
    end
  end

  context "with a mortgage on main property" do
    context "when on assets page" do
      before do
        visit estimate_build_estimate_path estimate_id, :property
        select_radio_value("property-form", "property-owned", "with_mortgage")
        click_on "Save and continue"

        fill_in "client-property-entry-form-house-value-field", with: 100_000
        fill_in "client-property-entry-form-mortgage-field", with: 50_000
        fill_in "client-property-entry-form-percentage-owned-field", with: 100
        click_on "Save and continue"
        select_boolean_value("vehicle-form", :vehicle_owned, false)
        click_on "Save and continue"
      end

      it "shows the correct page" do
        expect(page).to have_content assets_header
      end

      it "shows correct error for invalid valuables figure" do
        fill_in "client-assets-form-valuables-field", with: "400"

        click_on "Save and continue"
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Valuable items must be £500 or more, if this does not apply enter 0")
        end
      end

      it "sets error on assets form" do
        fill_in "client-assets-form-savings-field", with: "0"
        fill_in "client-assets-form-investments-field", with: "0"
        fill_in "client-assets-form-valuables-field", with: "0"

        click_on "Save and continue"
        expect(page).to have_css(".govuk-error-summary__list")
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Enter the estimated value of the additional property")
        end
      end
    end

    context "when on check answers" do
      before do
        visit_check_answers(passporting: true) do |step|
          case step
          when :property
            select_radio_value("property-form", "property-owned", "with_mortgage")
            click_on "Save and continue"

            fill_in "client-property-entry-form-house-value-field", with: 100_000
            fill_in "client-property-entry-form-mortgage-field", with: 50_000
            fill_in "client-property-entry-form-percentage-owned-field", with: 100
          when :assets
            if assets.present?
              fill_in "client-assets-form-savings-field", with: assets.fetch(:savings)
              click_checkbox("client-assets-form-in-dispute", "savings")
              fill_in "client-assets-form-investments-field", with: assets.fetch(:investments)
              fill_in "client-assets-form-valuables-field", with: assets.fetch(:valuables)
              click_checkbox("client-assets-form-in-dispute", "valuables")
            else
              fill_in "client-assets-form-savings-field", with: "0"
              fill_in "client-assets-form-investments-field", with: "0"
              fill_in "client-assets-form-valuables-field", with: "0"
            end

            if second_property.present?
              fill_in "client-assets-form-property-value-field", with: second_property.fetch(:value)
              fill_in "client-assets-form-property-mortgage-field", with: second_property.fetch(:mortgage)
              fill_in "client-assets-form-property-percentage-owned-field", with: second_property.fetch(:percentage)
            else
              fill_in "client-assets-form-property-value-field", with: "0"
            end
          end
        end
      end

      context "with a second property" do
        let(:assets) { nil }
        let(:second_property) do
          { value: 80_000, mortgage: 40_000, percentage: 50 }
        end

        it "can submit" do
          expect(mock_connection)
            .to receive(:create_properties)
                  .with(estimate_id, { main_home:
                                         { outstanding_mortgage: 50_000, percentage_owned: 100, value: 100_000, shared_with_housing_assoc: false },
                                       additional_properties: [
                                         { outstanding_mortgage: 40_000, percentage_owned: 50, value: 80_000, shared_with_housing_assoc: false },
                                       ] })

          expect(page).to have_content check_answers_header
          expect(page).to have_content "Additional property or holiday home: % owned"
          click_on "Submit"
        end
      end

      context "with non-zero savings and investments" do
        let(:second_property) { nil }
        let(:assets) { { savings: 100, investments: 500, valuables: 1_000 } }

        it "can submit" do
          expect(mock_connection)
            .to receive(:create_properties)
                  .with(estimate_id,
                        { main_home: { outstanding_mortgage: 50_000, percentage_owned: 100, value: 100_000, shared_with_housing_assoc: false } })
          expect(mock_connection).to receive(:create_capitals).with(
            estimate_id,
            { bank_accounts: [{ description: "Liquid Asset", value: 100, subject_matter_of_dispute: true }],
              non_liquid_capital: [{ description: "Non Liquid Asset", value: 500, subject_matter_of_dispute: false },
                                   { description: "Non Liquid Asset", value: 1_000, subject_matter_of_dispute: true }] },
          )

          expect(page).to have_content check_answers_header
          within "#savings" do
            expect(page).to have_content "Disputed asset"
          end
          within "#investments" do
            expect(page).not_to have_content "Disputed asset"
          end
          within "#valuables" do
            expect(page).to have_content "Disputed asset"
          end
          click_on "Submit"
        end
      end

      context "without assets" do
        let(:assets) { nil }
        let(:second_property) { nil }

        it "can skip the assets questions and get to results" do
          allow(mock_connection).to receive(:create_properties)
          allow(mock_connection).to receive(:create_applicant)
          allow(mock_connection).to receive(:create_regular_payments)

          expect(page).to have_content check_answers_header
          click_on "Submit"

          expect(page).to have_content "provisional declaration"
        end
      end
    end
  end

  context "with no mortgage on main property" do
    before do
      visit_check_answers(passporting: true) do |step|
        case step
        when :property
          select_radio_value("property-form", "property-owned", "outright")
          click_on "Save and continue"

          fill_in "client-property-entry-form-house-value-field", with: 100_000
          fill_in "client-property-entry-form-percentage-owned-field", with: 100
        when :assets
          fill_in "client-assets-form-savings-field", with: "0"
          fill_in "client-assets-form-investments-field", with: "0"
          fill_in "client-assets-form-valuables-field", with: "0"
          fill_in "client-assets-form-property-value-field", with: "80,000"
          fill_in "client-assets-form-property-mortgage-field", with: "40,000"
          fill_in "client-assets-form-property-percentage-owned-field", with: "50"
        end
      end
    end

    it "can submit second property" do
      allow(mock_connection).to receive(:create_regular_payments)
      allow(mock_connection).to receive(:create_applicant)
      expect(mock_connection)
        .to receive(:create_properties)
          .with(estimate_id,
                { main_home: { outstanding_mortgage: 0, percentage_owned: 100, value: 100_000, shared_with_housing_assoc: false },
                  additional_properties: [{ outstanding_mortgage: 40_000, percentage_owned: 50, value: 80_000, shared_with_housing_assoc: false }] })

      expect(page).to have_content check_answers_header
      click_on "Submit"
    end
  end
end
