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
  let(:partner_dependants_header) { "Tell us about your client's partner's dependants" }
  let(:benefits_page_header) { "Does your client's partner receive Housing Benefit?" }

  before do
    travel_to arbitrary_fixed_time
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    visit_applicant_page
    fill_in_applicant_screen_without_passporting_benefits
    click_on("Save and continue")
    skip_dependants_form
    skip_benefits_form
    complete_incomes_screen
    skip_outgoings_form
    skip_property_form
    skip_vehicle_form
    skip_assets_form
    add_applicant_partner_answers
    click_on("Save and continue")
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
    skip_partner_dependants_form
    expect(page).to have_content(benefits_page_header)
  end

  context "with dependants" do
    before do
      select_boolean_value("partner-dependant-details-form", :child_dependants, true)
      select_boolean_value("partner-dependant-details-form", :adult_dependants, true)
    end

    it "requires me to enter dependant counts" do
      click_on "Save and continue"
      within ".govuk-error-summary__list" do
        expect(all("li").map(&:text))
          .to eq([
            "Please enter the number of child dependants",
            "Please enter the number of adult dependants",
          ])
      end
    end

    it "required a non-zero dependant count" do
      fill_in "Adult dependants", with: "0"
      fill_in "Child dependants", with: "0"
      click_on "Save and continue"
      expect(page).to have_content("Number of adult dependants must be greater than zero")
      expect(page).to have_content("Number of child dependants must be greater than zero")
    end

    context "with partner dependant numbers" do
      before do
        fill_in "Adult dependants", with: "1"
        fill_in "Child dependants", with: "2"
        click_on "Save and continue"
        skip_partner_benefits_form
        complete_incomes_screen(subject: :partner)
        skip_outgoings_form(subject: :partner)
        skip_partner_property_form
        select_boolean_value("partner-vehicle-form", "vehicle_owned", false)
        click_on "Save and continue"
        skip_assets_form(subject: :partner)
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
end
