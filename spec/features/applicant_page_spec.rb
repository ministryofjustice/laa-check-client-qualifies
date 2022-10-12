require "rails_helper"

RSpec.describe "Applicant Page" do
  let(:income_header) { "What other income does your client receive?" }
  let(:property_header) { "Does your client own the home they live in?" }
  let(:applicant_header) { "About your client" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

  describe "errors" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      allow(mock_connection).to receive(:create_proceeding_type)
      visit_applicant_page

      %i[over_60 dependants partner passporting employed].reject { |f| f == field }.each do |f|
        select_applicant_boolean(f, true)
      end
      click_on "Save and continue"
    end

    context "when over_60 is omitted" do
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

    context "when employed is omitted" do
      let(:field) { :employed }

      it "displays the correct error message" do
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select employed if the client is currently employed")
        end
      end
    end

    context "when dependants is omitted" do
      let(:field) { :dependants }

      it "displays the correct error message" do
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes if the client has any dependants")
        end
      end
    end

    context "when partner is omitted" do
      let(:field) { :partner }

      it "displays the correct error message" do
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes if the client has a partner")
        end
      end
    end

    context "when passporting is omitted" do
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
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      allow(mock_connection).to receive(:create_proceeding_type)
      visit_applicant_page

      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:dependants, true)
      select_applicant_boolean(:partner, false)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, false)
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
      fill_in "applicant-form-dependant-count-field", with: "1"
      click_on "Save and continue"
      expect(page).to have_content income_header
    end
  end

  describe "submitting over_60 field" do
    let(:calculation_result) do
      CalculationResult.new(result_summary: { overall_result: { result: "contribution_required", income_contribution: 12_345.78 } })
    end

    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      allow(mock_connection).to receive(:create_proceeding_type)
      visit_applicant_page

      select_applicant_boolean(:over_60, over_60)
      select_applicant_boolean(:dependants, false)
      select_applicant_boolean(:partner, false)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, true)
      click_on "Save and continue"

      click_checkbox("property-form-property-owned", "none")
      click_on "Save and continue"
      select_boolean_value("vehicle-form", :vehicle_owned, false)
      click_on "Save and continue"
      click_checkbox("assets-form-assets", "none")
      click_on "Save and continue"

      allow(mock_connection).to receive(:api_result).and_return(calculation_result)
    end

    context "when over 60" do
      let(:over_60) { true }
      let(:date_of_birth) { (Time.zone.today - 70.years).to_date }

      it "sets age to 70" do
        expect(mock_connection).to receive(:create_applicant)
                                     .with(estimate_id, date_of_birth:,
                                                        receives_qualifying_benefit: true)

        expect(page).to have_content "Summary Page"
        click_on "Submit"
        expect(page).to have_content "£12,345.78 per month"
      end
    end

    context "when under 60" do
      let(:over_60) { false }
      let(:date_of_birth) { (Time.zone.today - 50.years).to_date }

      it "sets age to 50" do
        expect(mock_connection).to receive(:create_applicant)
                                     .with(estimate_id, date_of_birth:,
                                                        receives_qualifying_benefit: true)
        expect(page).to have_content "Summary Page"
        click_on "Submit"
      end
    end
  end

  describe "applicant page flow", :vcr do
    let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }

    before do
      travel_to arbitrary_fixed_time
      visit_applicant_page
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:partner, false)
      select_applicant_boolean(:employed, false)
    end

    describe "passporting" do
      before do
        select_applicant_boolean(:dependants, false)
        select_applicant_boolean(:passporting, passporting)
      end

      context "when passporting" do
        let(:passporting) { true }

        before do
          click_on "Save and continue"
        end

        it "skips income and outgoings" do
          expect(page).to have_content property_header
        end

        it "has a back pointer to the applicant page" do
          click_on "Back"
          expect(page).to have_content applicant_header
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

        it "has a back pointer to the applicant page" do
          click_on "Back"
          expect(page).to have_content applicant_header
        end
      end
    end

    describe "dependants field" do
      before do
        select_applicant_boolean(:dependants, true)
        select_applicant_boolean(:passporting, false)
      end

      it "submits dependants" do
        fill_in "applicant-form-dependant-count-field", with: "2"
        click_on "Save and continue"
        expect(page).to have_content income_header
      end
    end
  end
end
