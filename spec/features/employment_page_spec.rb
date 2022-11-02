require "rails_helper"

RSpec.describe "Employment page" do
  let(:employment_page_header) { "Add your client's salary breakdown" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }
  let(:calculation_result) do
    CalculationResult.new(result_summary: { overall_result: { result: "contribution_required", income_contribution: 12_345.78 } })
  end

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    allow(mock_connection).to receive(:create_proceeding_type)
    allow(mock_connection).to receive(:create_regular_payments)
    allow(mock_connection).to receive(:create_applicant)
    allow(mock_connection).to receive(:create_benefits)
    allow(mock_connection).to receive(:create_irregular_income)
    allow(mock_connection).to receive(:api_result).and_return(calculation_result)
    visit_applicant_page
  end

  context "when I have indicated that I am not employed" do
    before do
      fill_in_applicant_screen_without_passporting_benefits
      select_applicant_boolean(:employed, false)
      click_on "Save and continue"
    end

    it "skips the employment page" do
      expect(page).not_to have_content(employment_page_header)
    end
  end

  context "when I have indicated that I am employed" do
    before do
      fill_in_applicant_screen_without_passporting_benefits
      select_applicant_boolean(:employed, true)
      click_on "Save and continue"
    end

    it "shows the employment page" do
      expect(page).to have_content(employment_page_header)
    end

    it "has a back link to the applicant info page" do
      click_link "Back"
      expect(page).to have_content "Your client's details"
    end

    context "when I enter negative income by mistake" do
      before do
        fill_in "employment-form-gross-income-field", with: 100
        fill_in "employment-form-income-tax-field", with: 100
        fill_in "employment-form-national-insurance-field", with: 50
        click_checkbox("employment-form-frequency", "monthly")
        click_on "Save and continue"
      end

      it "shows a friendly error message" do
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Net income must be positive, please check")
        end
      end
    end

    context "when I omit some required information" do
      before do
        click_on "Save and continue"
      end

      it "shows me an error message" do
        expect(page).to have_content employment_page_header
        expect(page).to have_content "Income cannot be blank"
      end
    end

    context "when I provide all required information" do
      before do
        fill_in "employment-form-gross-income-field", with: "5,000"
        fill_in "employment-form-income-tax-field", with: "1000"
        fill_in "employment-form-national-insurance-field", with: 50.5
        click_checkbox("employment-form-frequency", "monthly")
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

        click_on "Save and continue"
        expect(page).not_to have_content employment_page_header
        progress_to_submit_from_benefits
      end

      it "formats my answers appropriately if I return to the screen" do
        allow(mock_connection).to receive(:create_employment)
        click_on "Save and continue"
        click_on "Back"
        expect(find("#employment-form-gross-income-field").value).to eq "5,000"
        expect(find("#employment-form-income-tax-field").value).to eq "1,000"
        expect(find("#employment-form-national-insurance-field").value).to eq "50.50"
      end
    end

    context "when I provide different frequencies" do
      before do
        fill_in "employment-form-gross-income-field", with: 1000
        fill_in "employment-form-income-tax-field", with: 100
        fill_in "employment-form-national-insurance-field", with: 50
      end

      it "handles 3-month total" do
        expect(mock_connection).to receive(:create_employment) do |_id, params|
          payment = params.dig(0, :payments, 1)
          expect(payment[:gross]).to eq (1_000 / 3.0).round(2)
          expect(payment[:date]).to eq 1.month.ago.to_date
        end
        click_checkbox("employment-form-frequency", "total")

        click_on "Save and continue"
        progress_to_submit_from_benefits
      end

      it "handles 1 week" do
        expect(mock_connection).to receive(:create_employment) do |_id, params|
          payment = params.dig(0, :payments, 1)
          expect(payment[:gross]).to eq 1_000
          expect(payment[:date]).to eq 1.week.ago.to_date
        end
        click_checkbox("employment-form-frequency", "week")
        click_on "Save and continue"
        progress_to_submit_from_benefits
      end

      it "handles two weeks" do
        expect(mock_connection).to receive(:create_employment) do |_id, params|
          payment = params.dig(0, :payments, 1)
          expect(payment[:gross]).to eq 1_000
          expect(payment[:date]).to eq 2.weeks.ago.to_date
        end
        click_checkbox("employment-form-frequency", "two_weeks")
        click_on "Save and continue"
        progress_to_submit_from_benefits
      end

      it "handles four weeks" do
        expect(mock_connection).to receive(:create_employment) do |_id, params|
          payment = params.dig(0, :payments, 1)
          expect(payment[:gross]).to eq 1_000
          expect(payment[:date]).to eq 4.weeks.ago.to_date
        end
        click_checkbox("employment-form-frequency", "four_weeks")
        click_on "Save and continue"
        progress_to_submit_from_benefits
      end

      it "handles annually" do
        expect(mock_connection).to receive(:create_employment) do |_id, params|
          payment = params.dig(0, :payments, 1)
          expect(payment[:gross]).to eq (1_000 / 12.0).round(2)
          expect(payment[:date]).to eq 1.month.ago.to_date
        end
        click_checkbox("employment-form-frequency", "annually")
        click_on "Save and continue"
        progress_to_submit_from_benefits
      end
    end
  end
end
