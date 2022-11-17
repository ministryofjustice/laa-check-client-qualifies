require "rails_helper"

RSpec.describe "Applicant Page" do
  let(:applicant_header_with_partner) { I18n.t("estimate_flow.applicant.heading_with_partner") }
  let(:applicant_header_without_partner) { I18n.t("estimate_flow.applicant.heading") }
  let(:partner_age_question) { I18n.t("estimate_flow.applicant.partner_over_60.legend") }
  let(:partner_employment_question) { I18n.t("estimate_flow.applicant.partner_employed.legend") }

  describe "errors" do
    before do
      visit_applicant_page

      %i[over_60 passporting employed].reject { |f| f == field }.each do |f|
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

    context "when passporting is omitted" do
      let(:field) { :passporting }

      it "displays the correct error message" do
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes if the client is currently in receipt of a passporting benefit")
        end
      end
    end
  end

  describe "submitting over_60 field" do
    let(:estimate_id) { SecureRandom.uuid }
    let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }
    let(:calculation_result) { CalculationResult.new FactoryBot.build(:api_result) }

    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      allow(mock_connection).to receive(:create_proceeding_type)
      allow(mock_connection).to receive(:create_regular_payments)
      visit_applicant_page

      select_applicant_boolean(:over_60, over_60)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, true)
      click_on "Save and continue"

      select_radio_value("property-form", "property-owned", "none")
      click_on "Save and continue"
      select_boolean_value("vehicle-form", :vehicle_owned, false)
      click_on "Save and continue"
      skip_assets_form
      allow(mock_connection).to receive(:api_result).and_return(calculation_result)
    end

    context "when over 60" do
      let(:over_60) { true }
      let(:date_of_birth) { (Time.zone.today - 70.years).to_date }

      it "sets age to 70" do
        expect(mock_connection).to receive(:create_applicant)
                                     .with(estimate_id, date_of_birth:,
                                                        receives_qualifying_benefit: true,
                                                        employed: false)

        click_on "Submit"
      end
    end

    context "when under 60" do
      let(:over_60) { false }
      let(:date_of_birth) { (Time.zone.today - 50.years).to_date }

      it "sets age to 50" do
        expect(mock_connection).to receive(:create_applicant)
                                     .with(estimate_id, date_of_birth:,
                                                        receives_qualifying_benefit: true,
                                                        employed: false)
        click_on "Submit"
      end
    end
  end

  describe "without a partner" do
    before do
      visit_applicant_page
    end

    it "shows me the right header" do
      expect(page).to have_content applicant_header_without_partner
    end
  end

  describe "with a partner" do
    before do
      visit_applicant_page_with_partner
    end

    it "shows me the right content" do
      expect(page).to have_content applicant_header_without_partner
      expect(page).to have_content partner_age_question
      expect(page).to have_content partner_employment_question
    end

    it "complains if I don't fill in additional questions" do
      select_applicant_boolean(:over_60, true)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, true)
      click_on "Save and continue"
      expect(page).to have_css(".govuk-error-summary__list")
    end

    it "allows me to progress if I do fill in additional questions" do
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, true)
      select_applicant_boolean(:partner_over_60, true)
      select_applicant_boolean(:partner_employed, false)
      click_on "Save and continue"
      expect(page).not_to have_css(".govuk-error-summary__list")
    end
  end

  describe "applicant page flow", :vcr do
    let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
    let(:dependants_page_header) { I18n.t("estimate_flow.dependants.legend") }
    let(:applicant_page_header) { I18n.t("estimate_flow.applicant.caption") }

    before do
      travel_to arbitrary_fixed_time
      visit_applicant_page
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, false)
      click_on "Save and continue"
    end

    it "goes on to dependants screen" do
      expect(page).to have_content dependants_page_header
    end

    it "has a back pointer to the applicant page" do
      click_on "Back"
      expect(page).to have_content applicant_page_header
    end
  end
end
