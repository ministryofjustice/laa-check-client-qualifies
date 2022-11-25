require "rails_helper"

RSpec.describe "Applicant Page" do
  let(:applicant_header) { I18n.t("estimate_flow.applicant.heading") }

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

      select_radio_value("applicant-form", "proceeding-type", "se003") # non-domestic abuse case
      select_applicant_boolean(:over_60, over_60)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, true)
      select_applicant_boolean(:dependants, false)

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
                                     .with(estimate_id, { date_of_birth:,
                                                          has_partner_opponent: false,
                                                          receives_qualifying_benefit: true,
                                                          employed: false })

        click_on "Submit"
      end
    end

    context "when under 60" do
      let(:over_60) { false }
      let(:date_of_birth) { (Time.zone.today - 50.years).to_date }

      it "sets age to 50" do
        expect(mock_connection).to receive(:create_applicant)
                                     .with(estimate_id, { date_of_birth:,
                                                          has_partner_opponent: false,
                                                          receives_qualifying_benefit: true,
                                                          employed: false })
        click_on "Submit"
      end
    end
  end

  describe "with a partner" do
    around do |example|
      Flipper.enable(:partner)
      example.run
      Flipper.disable(:partner)
    end

    before do
      visit_applicant_page
    end

    it "shows me the right content" do
      expect(page).to have_content applicant_header
    end

    it "complains if I don't fill in additional questions - omitting domestic abuse and partner" do
      select_applicant_boolean(:over_60, true)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, true)
      select_applicant_boolean(:dependants, false)
      click_on "Save and continue"
      expect(page).to have_css(".govuk-error-summary__list")
    end

    it "allows me to progress if I do fill in additional questions" do
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, true)
      select_applicant_boolean(:partner, true)
      select_applicant_boolean(:dependants, false)
      select_radio_value("applicant-form", "proceeding-type", "se003") # non-domestic abuse case
      click_on "Save and continue"
      expect(page).not_to have_css(".govuk-error-summary__list")
    end

    it "shows me partner details on the check answers screen" do
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, true)
      select_applicant_boolean(:partner, true)
      select_applicant_boolean(:dependants, false)
      select_radio_value("applicant-form", "proceeding-type", "se003")
      click_on "Save and continue"
      skip_property_form
      expect(page).to have_content "Does your client own a vehicle?"
      select_boolean_value("vehicle-form", :vehicle_owned, false)
      click_on "Save and continue"
      skip_assets_form

      select_boolean_value("partner-details-form", :over_60, false)
      select_boolean_value("partner-details-form", :employed, false)
      select_boolean_value("partner-details-form", :dependants, false)
      click_on "Save and continue"

      skip_partner_property_form
      click_on "Save and continue"
      expect(page).to have_content "Does your client's partner own a vehicle?"
      select_boolean_value("partner-vehicle-form", :vehicle_owned, false)
      click_on "Save and continue"
      skip_assets_form(subject: :partner)
      expect(page).to have_content I18n.t(".estimates.check_answers.partner_details")
      expect(page).to have_content I18n.t(".estimates.check_answers.partner_details_fields.partner_over_60")
      expect(page).to have_content I18n.t(".estimates.check_answers.partner_details_fields.partner_employed")
      expect(page).to have_content I18n.t(".estimates.check_answers.partner_details_fields.partner_dependants")
      expect(page).to have_content "Has a partnerYes"
    end
  end

  describe "applicant page flow", :vcr, :partner_flag do
    let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
    let(:dependant_details_page_header) { I18n.t("estimate_flow.dependant_details.legend") }
    let(:applicant_page_header) { I18n.t("estimate_flow.applicant.caption") }

    before do
      travel_to arbitrary_fixed_time
      visit_applicant_page
      select_radio_value("applicant-form", "proceeding-type", "se003") # non-domestic abuse case
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:partner, false)
      select_applicant_boolean(:employed, false)
      select_applicant_boolean(:passporting, false)
      select_applicant_boolean(:dependants, true)
      click_on "Save and continue"
    end

    it "goes on to dependants details screen" do
      expect(page).to have_content dependant_details_page_header
    end

    it "displays error messages if nothing is entered" do
      click_on "Save and continue"
      expect(page).to have_content("Please enter a zero if the client has no child dependants")
      expect(page).to have_content("Please enter a zero if the client has no adult dependants")
    end

    it "has a back pointer to the applicant page" do
      click_on "Back"
      expect(page).to have_content applicant_page_header
    end
  end
end
