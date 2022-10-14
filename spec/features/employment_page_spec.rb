require "rails_helper"

RSpec.describe "Employment page" do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:employment_page_header) { "Add your client's salary breakdown" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

  before do
    travel_to arbitrary_fixed_time
    visit new_estimate_path
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

      it "moves me on to the next question" do
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
        select "Total in last 3 months", from: "employment-form-frequency-field"
        click_on "Save and continue"
      end

      it "handles 1 week" do
        select "Every week", from: "employment-form-frequency-field"
        click_on "Save and continue"
      end

      it "handles two weeks" do
        select "Every two weeks", from: "employment-form-frequency-field"
        click_on "Save and continue"
      end

      it "handles four weeks" do
        select "Every four weeks", from: "employment-form-frequency-field"
        click_on "Save and continue"
      end

      it "handles annually" do
        select "Annually", from: "employment-form-frequency-field"
        click_on "Save and continue"
      end
    end
  end
end
