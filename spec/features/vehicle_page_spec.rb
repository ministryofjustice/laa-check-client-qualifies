require "rails_helper"

RSpec.describe "Vehicle Page" do
  let(:assets_header) { "Which of these assets does your client have?" }
  let(:check_answers_header) { "Check your answers" }

  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) do
    instance_double(
      CfeConnection,
      api_result: CalculationResult.new(FactoryBot.build(:api_result)),
      create_assessment_id: estimate_id,
      create_proceeding_type: nil,
      create_applicant: nil,
      create_regular_payments: nil,
    )
  end

  context "when on vehicle form" do
    before do
      visit estimate_build_estimate_path estimate_id, :vehicle
    end

    it "sets error on vehicle form" do
      click_on "Save and continue"
      expect(page).to have_css(".govuk-error-summary__list")
      within ".govuk-error-summary__list" do
        expect(page).to have_content("Select yes if the client owns a vehicle")
      end
    end

    context "without a vehicle" do
      before do
        select_vehicle_value(:vehicle_owned, false)
        click_on "Save and continue"
      end

      it "skips vehicle questions" do
        expect(page).to have_content(assets_header)
      end
    end

    context "with a vehicle" do
      before do
        select_vehicle_value(:vehicle_owned, true)
        click_on "Save and continue"
      end

      it "has readable errors" do
        click_on "Save and continue"

        expect(page).to have_css(".govuk-error-summary__list")
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes if the vehicle is in regular use")
          expect(page).to have_content("Please enter the estimated value")
        end
      end
    end
  end

  context "when checking answers" do
    context "without a vehicle" do
      before do
        allow(mock_connection).to receive(:create_capitals)
        visit_check_answers(passporting: true) do |step|
          case step
          when :vehicle
            select_vehicle_value(:vehicle_owned, false)
          end
        end
      end

      it "has expected content" do
        expect(page).to have_content check_answers_header
        within("#field-list-vehicles") do
          expect(page).to have_content "No"
        end
      end

      it "can do a simple loop back to check answers" do
        within("#subsection-vehicles-header") { click_on "Change" }
        click_on "Save and continue"
        expect(page).to have_content check_answers_header
      end

      it "errors correctly if I decline to give further details of a vehicle" do
        within("#subsection-vehicles-header") { click_on "Change" }
        select_vehicle_value(:vehicle_owned, true)
        click_on "Save and continue"

        fill_in "client-vehicle-details-form-vehicle-value-field", with: 20_000
        click_on "Save and continue"

        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes if the vehicle is in regular use")
        end
      end

      it "can do a loop changing the vehicle answer" do
        allow(CfeConnection).to receive(:connection).and_return(mock_connection)

        within("#subsection-vehicles-header") { click_on "Change" }
        select_vehicle_value(:vehicle_owned, true)
        click_on "Save and continue"
        fill_in "client-vehicle-details-form-vehicle-value-field", with: 20_000
        select_boolean_value("client-vehicle-details-form", :vehicle_in_regular_use, false)
        select_boolean_value("client-vehicle-details-form", :vehicle_pcp, false)
        select_boolean_value("client-vehicle-details-form", :vehicle_over_3_years_ago, true)
        click_on "Save and continue"
        expect(page.current_url).to end_with("check_answers#subsection-vehicles-header")

        expect(mock_connection).to receive(:create_vehicle)
        click_on "Submit"
      end
    end

    context "with a vehicle" do
      before do
        visit_check_answers(passporting: true) do |step|
          case step
          when :vehicle
            select_vehicle_value(:vehicle_owned, true)
            click_on "Save and continue"
            fill_in "client-vehicle-details-form-vehicle-value-field", with: 5_000
            select_boolean_value("client-vehicle-details-form", :vehicle_in_regular_use, true)
            select_boolean_value("client-vehicle-details-form", :vehicle_over_3_years_ago, over_3_years)
            select_boolean_value("client-vehicle-details-form", :vehicle_pcp, true)
            fill_in "client-vehicle-details-form-vehicle-finance-field", with: 2_000
            select_boolean_value("client-vehicle-details-form", :vehicle_in_dispute, true)
          end
        end
      end

      context "when purchased 3 years ago" do
        let(:over_3_years) { true }

        it "removes the dispute badge when vehicle removed" do
          within("#subsection-vehicles-header") do
            first(".govuk-link").click
          end
          select_vehicle_value(:vehicle_owned, false)
          click_on "Save and continue"

          within "#field-list-vehicles" do
            expect(page).not_to have_content "Disputed asset"
            expect(page).not_to have_content "5,000"
            expect(page).not_to have_content "2,000"
            expect(page).not_to have_content "Yes"
          end
        end

        it "uses 4 years old" do
          allow(CfeConnection).to receive(:connection).and_return(mock_connection)

          expect(mock_connection).to receive(:create_vehicle)
                                       .with(estimate_id,
                                             vehicles: [
                                               {
                                                 date_of_purchase: 4.years.ago.to_date,
                                                 in_regular_use: true,
                                                 loan_amount_outstanding: 2_000,
                                                 subject_matter_of_dispute: true,
                                                 value: 5_000,
                                               },
                                             ])

          within "#field-list-vehicles" do
            expect(page).to have_content "Disputed asset"
          end

          click_on "Submit"
        end
      end

      context "when purchased recently" do
        let(:over_3_years) { false }

        it "uses 2 years old" do
          allow(CfeConnection).to receive(:connection).and_return(mock_connection)

          expect(mock_connection).to receive(:create_vehicle)
                                       .with(estimate_id,
                                             vehicles: [
                                               {
                                                 date_of_purchase: 2.years.ago.to_date,
                                                 in_regular_use: true,
                                                 loan_amount_outstanding: 2_000,
                                                 subject_matter_of_dispute: true,
                                                 value: 5_000,
                                               },
                                             ])
          click_on "Submit"
        end
      end
    end
  end

  def select_vehicle_value(field, value)
    select_boolean_value("vehicle-form", field, value)
  end
end
