require "rails_helper"

RSpec.describe "Partner Dependants", :partner_flag do
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) do
    instance_double(CfeConnection,
                    create_assessment_id: estimate_id,
                    create_proceeding_type: nil,
                    create_benefits: nil,
                    create_irregular_income: nil,
                    create_regular_payments: nil,
                    create_applicant: nil,
                    api_result: calculation_result)
  end
  let(:calculation_result) { CalculationResult.new(FactoryBot.build(:api_result)) }
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 10, 17, 9, 0, 0) }
  let(:partner_dependants_header) { I18n.t("estimate_flow.partner_dependant_details.legend") }
  let(:benefits_page_header) { I18n.t("estimate_flow.partner_housing_benefit.housing_benefit_received.legend") }

  context "when on dependants screen" do
    before do
      visit_flow_page(passporting: false, partner: true, target: :partner_dependants)
    end

    it "arrives at the correct screen" do
      expect(page).to have_content(partner_dependants_header)
    end

    it "checks I have made a choice" do
      click_on("Save and continue")
      within ".govuk-error-summary__list" do
        expect(page).to have_content("Please select yes if client's partner has adult dependants")
        expect(page).to have_content("Please select yes if client's partner has child dependants")
      end
    end

    it "allows me to skip past the details screen" do
      select_boolean_value("partner-dependant-details-form", :child_dependants, false)
      select_boolean_value("partner-dependant-details-form", :adult_dependants, false)
      click_on "Save and continue"
      expect(page).to have_content(benefits_page_header)
    end
  end

  context "with dependants" do
    before do
      visit_flow_page(passporting: false, partner: true, target: :partner_dependants)

      select_boolean_value("partner-dependant-details-form", :child_dependants, true)
      select_boolean_value("partner-dependant-details-form", :adult_dependants, true)
    end

    it "requires me to enter dependant counts" do
      click_on "Save and continue"
      within ".govuk-error-summary__list" do
        expect(all("li").map(&:text))
          .to eq([
            "Enter the number of child dependants",
            "Enter the number of adult dependants",
          ])
      end
    end

    it "required a non-zero dependant count" do
      fill_in "partner-dependant-details-form-adult-dependants-count-field", with: "0"
      fill_in "partner-dependant-details-form-child-dependants-count-field", with: "0"
      click_on "Save and continue"
      expect(page).to have_content("The number of child dependants must be greater than zero")
      expect(page).to have_content("The number of adult dependants must be greater than zero")
    end
  end

  context "with partner dependant numbers" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)

      visit_check_answers(passporting: false, partner: true) do |step|
        case step
        when :partner_dependants
          select_boolean_value("partner-dependant-details-form", :child_dependants, true)
          select_boolean_value("partner-dependant-details-form", :adult_dependants, true)

          fill_in "partner-dependant-details-form-adult-dependants-count-field", with: "1"
          fill_in "partner-dependant-details-form-child-dependants-count-field", with: "2"
        end
      end
    end

    it "passes partner dependants to CFE" do
      expect(mock_connection).to receive(:create_partner) do |_estimate_id, params|
        dependants = params.fetch(:dependants)
        expect(dependants.count { (Time.zone.today - _1[:date_of_birth]).days < 18.years }).to eq 2
        expect(dependants.count { (Time.zone.today - _1[:date_of_birth]).days > 18.years }).to eq 1
      end

      click_on "Submit"
    end

    it "can do a check answers loop" do
      within "#field-list-partner_dependant_details" do
        expect(page).to have_content "Partner has child dependants"
      end
      within "#subsection-partner_dependant_details-header" do
        click_on "Change"
      end

      select_boolean_value("partner-dependant-details-form", :child_dependants, false)
      click_on "Save and continue"
      within "#field-list-partner_dependant_details" do
        expect(page).to have_content "Partner has child dependantsNo"
      end
    end
  end
end
