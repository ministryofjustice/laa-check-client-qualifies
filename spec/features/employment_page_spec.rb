require "rails_helper"

RSpec.describe "Employment page" do
  let(:employment_page_header) { "Add your client's salary breakdown" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    allow(mock_connection).to receive(:create_proceeding_type)
    visit_applicant_page
  end

  context "when I have indicated that I am not employed" do
    before do
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:dependants, false)
      select_applicant_boolean(:partner, false)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, false)
      click_on "Save and continue"
    end

    it "skips the employment page" do
      expect(page).not_to have_content(employment_page_header)
    end
  end

  context "when I have indicated that I am employed" do
    before do
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:dependants, false)
      select_applicant_boolean(:partner, false)
      select_applicant_boolean(:employed, true)
      select_applicant_boolean(:passporting, false)
      click_on "Save and continue"
    end

    it "shows the employment page" do
      expect(page).to have_content(employment_page_header)
    end

    it "has a back link to the applicant info page" do
      click_link "Back"
      expect(page).to have_content "Your client's details"
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
        fill_in "employment-form-gross-income-field", with: 1000
        fill_in "employment-form-income-tax-field", with: 100
        fill_in "employment-form-national-insurance-field", with: 50
        select "Monthly", from: "employment-form-frequency-field"
      end

      it "persists my answers to CFE and moves me on to the next question" do
        expect(mock_connection).to receive(:create_employment) do |id, params|
          expect(id).to eq estimate_id
          payment = params.dig(0, :payments, 1)
          expect(payment[:gross]).to eq 1_000
          expect(payment[:tax]).to eq(-100)
          expect(payment[:national_insurance]).to eq(-50)
          expect(payment[:date]).to eq 1.month.ago.to_date
        end

        click_on "Save and continue"
        expect(page).not_to have_content employment_page_header
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
        select "Total in last 3 months", from: "employment-form-frequency-field"
        click_on "Save and continue"
      end

      it "handles 1 week" do
        expect(mock_connection).to receive(:create_employment) do |_id, params|
          payment = params.dig(0, :payments, 1)
          expect(payment[:gross]).to eq 1_000
          expect(payment[:date]).to eq 1.week.ago.to_date
        end
        select "Every week", from: "employment-form-frequency-field"
        click_on "Save and continue"
      end

      it "handles two weeks" do
        expect(mock_connection).to receive(:create_employment) do |_id, params|
          payment = params.dig(0, :payments, 1)
          expect(payment[:gross]).to eq 1_000
          expect(payment[:date]).to eq 2.weeks.ago.to_date
        end
        select "Every two weeks", from: "employment-form-frequency-field"
        click_on "Save and continue"
      end

      it "handles four weeks" do
        expect(mock_connection).to receive(:create_employment) do |_id, params|
          payment = params.dig(0, :payments, 1)
          expect(payment[:gross]).to eq 1_000
          expect(payment[:date]).to eq 4.weeks.ago.to_date
        end
        select "Every four weeks", from: "employment-form-frequency-field"
        click_on "Save and continue"
      end

      it "handles annually" do
        expect(mock_connection).to receive(:create_employment) do |_id, params|
          payment = params.dig(0, :payments, 1)
          expect(payment[:gross]).to eq (1_000 / 12.0).round(2)
          expect(payment[:date]).to eq 1.month.ago.to_date
        end
        select "Annually", from: "employment-form-frequency-field"
        click_on "Save and continue"
      end
    end
  end
end
