require "rails_helper"

RSpec.describe "Employment page" do
  let(:employment_page_header) { I18n.t("estimate_flow.employment.heading") }
  let(:dependant_question) { I18n.t("estimate_flow.dependant_details.legend") }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }
  let(:calculation_result) do
    CalculationResult.new(build(:api_result))
  end

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    allow(mock_connection).to receive(:create_proceeding_type)
    allow(mock_connection).to receive(:create_regular_payments)
    allow(mock_connection).to receive(:create_applicant)
    allow(mock_connection).to receive(:create_benefits)
    allow(mock_connection).to receive(:create_irregular_income)
    allow(mock_connection).to receive(:api_result).and_return(calculation_result)
  end

  context "when I have indicated that I am not employed" do
    it "skips the employment page" do
      visit_flow_page(passporting: false, target: :dependants)
      skip_dependants_form
      expect(page).not_to have_content(employment_page_header)
    end

    it "doesnt show section on check answers screen" do
      visit_check_answers(passporting: false)
      expect(page).not_to have_content "Gross income"
    end
  end

  context "when I have indicated that I am employed" do
    context "when on the employment screen" do
      before do
        visit_flow_page(passporting: false, target: :employment) do |step|
          case step
          when :applicant
            fill_in_applicant_screen_without_passporting_benefits
            select_radio_value("applicant-form", "employment-status", "in_work")
          end
        end
      end

      it "shows the employment page" do
        expect(page).to have_content(employment_page_header)
      end

      it "has a back link to the applicant form with the dependant question page" do
        click_link "Back"
        expect(page).to have_content dependant_question
      end

      context "when I enter negative income by mistake" do
        before do
          fill_in "employment-form-gross-income-field", with: 100
          fill_in "employment-form-income-tax-field", with: 100
          fill_in "employment-form-national-insurance-field", with: 50
          select_radio_value("employment-form", "frequency", "monthly")
          click_on "Save and continue"
        end

        it "shows a friendly error message" do
          within ".govuk-error-summary__list" do
            expect(page).to have_content("Employment income must be more than income tax and National Insurance combined")
          end
        end
      end

      context "when I omit some required information" do
        before do
          click_on "Save and continue"
        end

        it "shows me an error message" do
          expect(page).to have_content employment_page_header
          expect(page).to have_content "Enter employment income, before any deductions"
        end
      end

      context "when I enter something invalid" do
        before do
          fill_in "employment-form-gross-income-field", with: "5,000"
          fill_in "employment-form-income-tax-field", with: "1000"
          fill_in "employment-form-national-insurance-field", with: "foo"
          select_radio_value("employment-form", "frequency", "monthly")
          click_on "Save and continue"
        end

        it "shows me an error message" do
          expect(page).to have_content employment_page_header
          within ".govuk-error-summary__list" do
            expect(page.text).to eq "National Insurance must be a number, if this does not apply enter 0"
          end
        end
      end

      context "when extering correct information" do
        before do
          fill_in "employment-form-gross-income-field", with: "5,000"
          fill_in "employment-form-income-tax-field", with: "1000"
          fill_in "employment-form-national-insurance-field", with: 50.5
          select_radio_value("employment-form", "frequency", "monthly")
          click_on "Save and continue"
          click_on "Back"
        end

        it "formats my answers appropriately if I return to the screen" do
          expect(find("#employment-form-gross-income-field").value).to eq "5,000"
          expect(find("#employment-form-income-tax-field").value).to eq "1,000"
          expect(find("#employment-form-national-insurance-field").value).to eq "50.50"
        end
      end
    end

    context "when I provide all required information" do
      before do
        visit_check_answers(passporting: false) do |step|
          case step
          when :applicant
            fill_in_applicant_screen_without_passporting_benefits(partner: false)
            select_radio_value("applicant-form", "employment-status", "in_work")
          when :employment
            fill_in "employment-form-gross-income-field", with: "5,000"
            fill_in "employment-form-income-tax-field", with: "1000"
            fill_in "employment-form-national-insurance-field", with: 50.5
            select_radio_value("employment-form", "frequency", "monthly")
          end
        end
      end

      it "persists my answers to CFE and moves me on to the next question" do
        expect(mock_connection).to receive(:create_employment) do |id, params|
          expect(id).to eq estimate_id
          payment = params.dig(0, :payments, 1)
          expect(payment[:gross]).to eq 5_000
          expect(payment[:tax]).to eq(-1_000)
          expect(payment[:national_insurance]).to eq(-50.5)
          expect(payment[:date]).to eq 1.month.ago.to_date
        end

        click_on "Submit"
      end
    end

    context "when I provide different frequencies" do
      before do
        visit_check_answers(passporting: false) do |step|
          case step
          when :applicant
            fill_in_applicant_screen_without_passporting_benefits(partner: false)
            select_radio_value("applicant-form", "employment-status", "in_work")
          when :employment
            fill_in "employment-form-gross-income-field", with: 1000
            fill_in "employment-form-income-tax-field", with: 100
            fill_in "employment-form-national-insurance-field", with: 50
            select_radio_value("employment-form", "frequency", frequency)
          end
        end
      end

      context "with 3-month total" do
        let(:frequency) { "total" }

        it "submits correctly to CFE" do
          expect(mock_connection).to receive(:create_employment) do |_id, params|
            payment = params.dig(0, :payments, 1)
            expect(payment[:gross]).to eq (1_000 / 3.0).round(2)
            expect(payment[:date]).to eq 1.month.ago.to_date
            expect(payment[:national_insurance]).to eq (-50 / 3.0).round(2)
            expect(payment[:tax]).to eq (-100 / 3.0).round(2)
          end
          click_on "Submit"
        end
      end

      context "with 1 week" do
        let(:frequency) { "week" }

        it "submits to CFE" do
          expect(mock_connection).to receive(:create_employment) do |_id, params|
            payment = params.dig(0, :payments, 1)
            expect(payment[:gross]).to eq 1_000
            expect(payment[:date]).to eq 1.week.ago.to_date
            expect(payment[:national_insurance]).to eq(-50)
            expect(payment[:tax]).to eq(-100)
          end
          click_on "Submit"
        end
      end

      context "with two weeks" do
        let(:frequency) { "two_weeks" }

        it "submits to CFE" do
          expect(mock_connection).to receive(:create_employment) do |_id, params|
            payment = params.dig(0, :payments, 1)
            expect(payment[:gross]).to eq 1_000
            expect(payment[:date]).to eq 2.weeks.ago.to_date
            expect(payment[:national_insurance]).to eq(-50)
            expect(payment[:tax]).to eq(-100)
          end
          click_on "Submit"
        end
      end

      context "with four weeks" do
        let(:frequency) { "four_weeks" }

        it "submits to CFE" do
          expect(mock_connection).to receive(:create_employment) do |_id, params|
            payment = params.dig(0, :payments, 1)
            expect(payment[:gross]).to eq 1_000
            expect(payment[:date]).to eq 4.weeks.ago.to_date
            expect(payment[:national_insurance]).to eq(-50)
            expect(payment[:tax]).to eq(-100)
          end
          click_on "Submit"
        end
      end

      context "with annually" do
        let(:frequency) { "annually" }

        it "submits to CFE" do
          expect(mock_connection).to receive(:create_employment) do |_id, params|
            payment = params.dig(0, :payments, 1)
            expect(payment[:gross]).to eq (1_000 / 12.0).round(2)
            expect(payment[:date]).to eq 1.month.ago.to_date
            expect(payment[:national_insurance]).to eq (-50 / 12.0).round(2)
            expect(payment[:tax]).to eq (-100 / 12.0).round(2)
          end
          click_on "Submit"
        end
      end
    end
  end
end
