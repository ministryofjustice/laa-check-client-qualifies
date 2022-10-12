require "rails_helper"

RSpec.describe "Vehicle Page" do
  let(:property_header) { "Does your client own the home they live in?" }
  let(:vehicle_header) { "Does your client own a vehicle?" }
  let(:property_entry_header) { "How much is your client's home worth?" }
  let(:assets_header) { "Which assets does your client have?" }

  context "without property" do
    let(:estimate_id) { SecureRandom.uuid }
    let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)

      visit "/estimates/new"
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:dependants, false)
      select_applicant_boolean(:partner, false)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, true)
      click_on "Save and continue"

      click_checkbox("property-form-property-owned", "none")
      click_on "Save and continue"
    end

    it "has a back link to the property input form" do
      click_link "Back"
      expect(page).to have_content property_header
    end

    it "sets error on vehicle form" do
      click_on "Save and continue"
      expect(page).to have_css(".govuk-error-summary__list")
      within ".govuk-error-summary__list" do
        expect(page).to have_content("Select yes if the client owns a vehicle")
      end
    end

    it "skips questions when no selected" do
      select_vehicle_value(:vehicle_owned, false)
      click_on "Save and continue"
      expect(page).to have_content(assets_header)
    end

    context "with a vehicle" do
      before do
        select_vehicle_value(:vehicle_owned, true)
        click_on "Save and continue"
      end

      it "can go back to vehicle form with previous data" do
        click_on "Back"
        expect(page.find("#vehicle-form-vehicle-owned-true-field")).to be_checked
      end

      it "has readable errors" do
        click_on "Save and continue"

        expect(page).to have_css(".govuk-error-summary__list")
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes if the vehicle is in regular use")
          expect(page).to have_content("Please enter the estimated value")
        end
      end

      context "with a value" do
        let(:vehicle_value) { 10_000 }

        before do
          fill_in "vehicle-value-form-vehicle-value-field", with: vehicle_value
        end

        context "when in regular use" do
          let(:loan_amount) { 5_000 }

          before do
            select_boolean_value("vehicle-value-form", :vehicle_in_regular_use, true)
            click_on "Save and continue"
          end

          it "has readable errors" do
            click_on "Save and continue"
            within ".govuk-error-summary__list" do
              expect(page).to have_content("Select yes if the vehicle was purchased more than 3 years ago")
            end
          end

          context "when purchased 3 years ago" do
            it "uses 4 years old" do
              expect(mock_connection).to receive(:create_vehicle).with(estimate_id,
                                                                       date_of_purchase: 4.years.ago.to_date,
                                                                       value: vehicle_value,
                                                                       loan_amount_outstanding: loan_amount,
                                                                       in_regular_use: true)

              select_boolean_value("vehicle-age-form", :vehicle_over_3_years_ago, true)
              click_on "Save and continue"
              select_boolean_value("vehicle-finance-form", :vehicle_pcp, true)
              fill_in "vehicle-finance-form-vehicle-finance-field", with: loan_amount
              click_on "Save and continue"
            end
          end

          context "when purchased recently" do
            before do
              select_boolean_value("vehicle-age-form", :vehicle_over_3_years_ago, false)
              click_on "Save and continue"
            end

            it "uses 2 years old" do
              expect(mock_connection).to receive(:create_vehicle).with(estimate_id,
                                                                       date_of_purchase: 2.years.ago.to_date,
                                                                       value: vehicle_value,
                                                                       loan_amount_outstanding: loan_amount,
                                                                       in_regular_use: true)

              select_boolean_value("vehicle-finance-form", :vehicle_pcp, true)
              fill_in "vehicle-finance-form-vehicle-finance-field", with: loan_amount
              click_on "Save and continue"
              expect(page).to have_content assets_header
            end

            it "has a readable PCP error" do
              click_on "Save and continue"

              within ".govuk-error-summary__list" do
                expect(page).to have_content("Select yes if the vehicle has outstanding finance")
              end
            end

            context "with finance" do
              before do
                select_boolean_value("vehicle-finance-form", :vehicle_pcp, true)
              end

              it "has a readable error" do
                click_on "Save and continue"

                within ".govuk-error-summary__list" do
                  expect(page).to have_content("Please enter the outstanding finance amount")
                end
              end

              it "can be corrected" do
                fill_in "vehicle-finance-form-vehicle-finance-field", with: loan_amount
                expect(mock_connection).to receive(:create_vehicle).with(estimate_id,
                                                                         date_of_purchase: 2.years.ago.to_date,
                                                                         value: vehicle_value,
                                                                         loan_amount_outstanding: loan_amount,
                                                                         in_regular_use: true)

                click_on "Save and continue"
                expect(page).to have_content assets_header
                click_on "Back"
                select_boolean_value("vehicle-finance-form", :vehicle_pcp, false)
                expect(mock_connection).to receive(:create_vehicle).with(estimate_id,
                                                                         date_of_purchase: 2.years.ago.to_date,
                                                                         value: vehicle_value,
                                                                         loan_amount_outstanding: 0,
                                                                         in_regular_use: true)
                click_on "Save and continue"
              end
            end

            context "without a loan amount" do
              it "completes the journey successfully" do
                expect(mock_connection)
                  .to receive(:create_vehicle)
                        .with(estimate_id,
                              date_of_purchase: 2.years.ago.to_date,
                              value: vehicle_value,
                              loan_amount_outstanding: 0,
                              in_regular_use: true)

                select_boolean_value("vehicle-finance-form", :vehicle_pcp, false)
                click_on "Save and continue"
                expect(page).to have_content assets_header
              end
            end
          end
        end

        context "without regular usage" do
          it "creates the vehicle immediately" do
            expect(mock_connection)
              .to receive(:create_vehicle)
                    .with(estimate_id,
                          date_of_purchase: Time.zone.today.to_date,
                          value: vehicle_value,
                          loan_amount_outstanding: 0,
                          in_regular_use: false)
            select_boolean_value("vehicle-value-form", :vehicle_in_regular_use, false)
            click_on "Save and continue"

            expect(page).to have_content assets_header
          end

          it "has a working Back button" do
            expect(mock_connection)
              .to receive(:create_vehicle)
            select_boolean_value("vehicle-value-form", :vehicle_in_regular_use, false)
            click_on "Save and continue"
            expect(page).to have_content assets_header
            click_on "Back"
            expect(page).to have_content "Is the vehicle in regular use?"
          end
        end
      end
    end
  end

  context "when selecting property", :vcr do
    let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }

    before do
      travel_to arbitrary_fixed_time

      visit "/estimates/new"
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:dependants, false)
      select_applicant_boolean(:partner, false)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, true)
      click_on "Save and continue"

      click_checkbox("property-form-property-owned", "with_mortgage")
      click_on "Save and continue"

      fill_in "property-entry-form-house-value-field", with: 100_000
      fill_in "property-entry-form-mortgage-field", with: 50_000
      fill_in "property-entry-form-percentage-owned-field", with: 100
      click_on "Save and continue"
    end

    it "has a back link to the property input form" do
      click_link "Back"
      expect(page).to have_content property_entry_header
    end
  end

  def select_vehicle_value(field, value)
    select_boolean_value("vehicle-form", field, value)
  end
end
