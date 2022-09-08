require "rails_helper"

RSpec.describe "Welcome" do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:intro_header) { "About your client" }
  let(:property_header) { "Your client's property" }
  let(:vehicle_header) { "Does your client own a vehicle?" }
  let(:income_header) { "What income does your client receive?" }

  before do
    driven_by(:rack_test)
    travel_to arbitrary_fixed_time
  end

  context "when verifying date of birth" do
    let(:estimate_id) { SecureRandom.uuid }
    let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      visit "/estimates/new"
    end

    it "shows the intro page heading" do
      expect(page).to have_content intro_header
    end

    describe "errors" do
      before do
        %i[over_60 dependants partner passporting employed].reject { |f| f == field }.each do |f|
          select_boolean_value("intro-form", f, true)
        end
        click_on "Save and continue"
      end

      describe "over_60" do
        let(:field) { :over_60 }

        it "has an error section" do
          expect(page).to have_css(".govuk-error-summary__list")
        end

        it "displays the correct error message" do
          within ".govuk-error-summary__list" do
            expect(page).to have_content("Select yes if the client is over 60 years old")
          end
        end
      end

      describe "employed" do
        let(:field) { :employed }

        it "displays the correct error message" do
          within ".govuk-error-summary__list" do
            expect(page).to have_content("Select employed if the client is currently employed")
          end
        end
      end

      describe "dependants" do
        let(:field) { :dependants }

        it "displays the correct error message" do
          within ".govuk-error-summary__list" do
            expect(page).to have_content("Select yes if the client has any dependants")
          end
        end
      end

      describe "partner" do
        let(:field) { :partner }

        it "displays the correct error message" do
          within ".govuk-error-summary__list" do
            expect(page).to have_content("Select yes if the client has a partner")
          end
        end
      end

      describe "passporting" do
        let(:field) { :passporting }

        it "displays the correct error message" do
          within ".govuk-error-summary__list" do
            expect(page).to have_content("Select yes if the client is currently in receipt of a passporting benefit")
          end
        end
      end
    end

    describe "dependants field" do
      before do
        select_intro_boolean(:over_60, false)
        select_intro_boolean(:dependants, true)
        select_intro_boolean(:partner, false)
        select_intro_boolean(:employed, false)
        select_intro_boolean(:passporting, false)
      end

      it "errors when not typed" do
        click_on "Save and continue"
        expect(page).to have_css(".govuk-error-summary__list")
        within ".govuk-error-summary__list" do
          expect(page).to have_content("can't be blank")
        end
      end

      it "submits 1 dependant" do
        expect(mock_connection).to receive(:create_dependants).with(estimate_id, 1)
        fill_in "intro-form-dependant-count-field", with: "1"
        click_on "Save and continue"
        expect(page).to have_content income_header
      end
    end

    describe "submitting over_60 field" do
      before do
        select_intro_boolean(:over_60, over_60)
        select_intro_boolean(:dependants, false)
        select_intro_boolean(:partner, false)
        select_intro_boolean(:employed, false)
        select_intro_boolean(:passporting, true)
        click_on "Save and continue"

        click_checkbox("property-form-property-owned", "none")
        click_on "Save and continue"
        select_boolean_value("vehicle-form", :vehicle_owned, false)
        click_on "Save and continue"
        click_checkbox("assets-form-assets", "none")
        click_on "Save and continue"

        allow(mock_connection).to receive(:api_result).and_return(result_summary: { overall_result: { income_contribution: 0 } })
      end

      context "when over 60" do
        let(:over_60) { true }
        let(:date_of_birth) { (Time.zone.today - 61.years).to_date }

        it "sets age to 61" do
          expect(mock_connection).to receive(:create_applicant)
            .with(estimate_id, date_of_birth:,
                               receives_qualifying_benefit: true)

          expect(page).to have_content "Summary Page"
          click_on "Save and continue"
        end
      end

      context "when under 60" do
        let(:over_60) { false }
        let(:date_of_birth) { (Time.zone.today - 59.years).to_date }

        it "sets age to 59" do
          expect(mock_connection).to receive(:create_applicant)
            .with(estimate_id, date_of_birth:,
                               receives_qualifying_benefit: true)
          expect(page).to have_content "Summary Page"
          click_on "Save and continue"
        end
      end
    end
  end

  context "with vcr", :vcr do
    before do
      visit "/estimates/new"
    end

    describe "simple scenarios" do
      it "shows the Intro screen" do
        expect(page).to have_content intro_header
      end
    end

    describe "intro page flow" do
      before do
        select_intro_boolean(:over_60, false)
        select_intro_boolean(:dependants, false)
        select_intro_boolean(:partner, false)
        select_intro_boolean(:employed, false)
        select_intro_boolean(:passporting, passporting)
      end

      context "with dependants" do
        let(:passporting) { false }

        before do
          select_intro_boolean(:dependants, true)
          fill_in "intro-form-dependant-count-field", with: "1"
          click_on "Save and continue"
        end

        it "shows the next page" do
          expect(page).to have_content income_header
        end
      end

      context "when passporting" do
        let(:passporting) { true }

        before do
          click_on "Save and continue"
        end

        it "skips income and outgoings" do
          expect(page).to have_content "Property Page Template"
        end

        it "has a back pointer to the intro template" do
          click_on "Back"
          expect(page).to have_content intro_header
        end

        it "sets error on property form" do
          click_on "Save and continue"
          expect(page).to have_css(".govuk-error-summary__list")
          within ".govuk-error-summary__list" do
            expect(page).to have_content("Please select the option that best decribes your clients property ownership")
          end
        end

        it "can set property to mortage owned" do
          click_checkbox("property-form-property-owned", "with_mortgage")
          click_on "Save and continue"
          expect(page).to have_content property_header
          fill_in "property-entry-form-house-value-field", with: 100_000
          fill_in "property-entry-form-mortgage-field", with: 50_000
          fill_in "property-entry-form-percentage-owned-field", with: 100
          click_on "Save and continue"
          expect(page).to have_content vehicle_header
        end

        context "when getting to vehicle form" do
          before do
            click_checkbox("property-form-property-owned", "none")
            click_on "Save and continue"
          end

          it "has a back link to the property form" do
            click_link "Back"
            expect(page).to have_content "Property Page Template"
          end

          it "sets error on vehicle form" do
            click_on "Save and continue"
            expect(page).to have_css(".govuk-error-summary__list")
            within ".govuk-error-summary__list" do
              expect(page).to have_content("Select yes if the client owns a vehicle")
            end
          end

          context "when getting to assets form" do
            before do
              select_boolean_value("vehicle-form", :vehicle_owned, false)
              click_on "Save and continue"
            end

            it "sets error on assets form" do
              click_on "Save and continue"
              expect(page).to have_css(".govuk-error-summary__list")
              within ".govuk-error-summary__list" do
                expect(page).to have_content("Please select at least one option")
              end
            end

            it "can submit non-zero savings and investments" do
              click_checkbox("assets-form-assets", "savings")
              fill_in "assets-form-savings-field", with: "100"

              click_checkbox("assets-form-assets", "investments")
              fill_in "assets-form-investments-field", with: "500"

              click_on "Save and continue"

              expect(page).to have_content "Summary Page"
            end

            it "can fill in the assets questions and get to results" do
              click_checkbox("assets-form-assets", "none")
              click_on "Save and continue"

              expect(page).to have_content "Summary Page"
              click_on "Save and continue"

              expect(page).to have_content "Results Page"
            end
          end
        end
      end

      context "without passporting" do
        let(:passporting) { false }

        before do
          click_on "Save and continue"
        end

        it "shows income" do
          expect(page).to have_content income_header
        end

        it "handles student finance" do
          click_checkbox("monthly-income-form-monthly-incomes", "student_finance")
          fill_in "monthly-income-form-student-finance-field", with: "100"
          click_on "Save and continue"
        end

        it "handles friends or family and maintenance" do
          click_checkbox("monthly-income-form-monthly-incomes", "friends_or_family")
          fill_in "monthly-income-form-friends-or-family-field", with: "200"
          click_checkbox("monthly-income-form-monthly-incomes", "maintenance")
          fill_in "monthly-income-form-maintenance-field", with: "300"
          click_on "Save and continue"
          expect(page).to have_content("What are your client's monthly outgoings and deductions?")
        end

        it "validates presence of a checked field" do
          click_checkbox("monthly-income-form-monthly-incomes", "employment_income")
          click_on "Save and continue"
          within ".govuk-error-summary__list" do
            expect(page).to have_content("can't be blank")
          end
        end

        it "validates that at least one field is checked" do
          click_on "Save and continue"
          expect(page).to have_css(".govuk-error-summary__list")
          within ".govuk-error-summary__list" do
            expect(page).to have_content("Please select at least one option")
          end
        end

        it "moves onto outgoings with no income" do
          click_checkbox("monthly-income-form-monthly-incomes", "none")
          click_on "Save and continue"
          expect(page).to have_content("What are your client's monthly outgoings and deductions?")
        end

        describe "outgoings form" do
          before do
            click_checkbox("monthly-income-form-monthly-incomes", "none")
            click_on "Save and continue"
          end

          it "handles outgoings" do
            click_checkbox("outgoings-form-outgoings", "housing_payments")
            fill_in "outgoings-form-housing-payments-field", with: "300"
            click_on "Save and continue"
          end
        end
      end
    end
  end

  def click_checkbox(form_name, field)
    fieldname = field.to_s.tr("_", "-")
    find("label[for=#{form_name}-#{fieldname}-field]").click
  end

  def select_intro_boolean(field, value)
    select_boolean_value("intro-form", field, value)
  end

  def select_boolean_value(form_name, field, value)
    fieldname = field.to_s.tr("_", "-")
    if value
      find("label[for=#{form_name}-#{fieldname}-true-field]").click
    else
      find("label[for=#{form_name}-#{fieldname}-field]").click
    end
  end
end
