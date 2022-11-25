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
  let(:partner_dependants_header) { "Does your client's partner have any dependants?" }
  let(:benefits_page_header) { "Does your client's partner receive any benefits?" }

  before do
    travel_to arbitrary_fixed_time
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    visit_applicant_page
    fill_in_applicant_screen_without_passporting_benefits
    click_on("Save and continue")
    skip_benefits_form
    complete_incomes_screen
    skip_outgoings_form
    skip_property_form
    skip_vehicle_form
    skip_assets_form
  end

  it "arrives at the correct screen" do
    expect(page).to have_content(partner_dependants_header)
  end

  it "checks I have made a choice" do
    click_on("Save and continue")
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Select yes if the client's partner is over 60 years old")
      expect(page).to have_content("Select yes if the client's partner has any dependants")
      expect(page).to have_content("Select employed if the client's partner is currently employed")
    end

    # add_applicant_partner_answers
    expect(page).to have_content("Select yes if the client's partner has any dependants")
  end

  it "allows me to skip past the details screen" do
    add_applicant_partner_answers
    click_on("Save and continue")
    expect(page).to have_content(benefits_page_header)
  end

  it "requires me to enter dependants if I say I have them" do
    add_applicant_partner_answers(dependants: true)
    click_on "Save and continue"
    click_on "Save and continue"
    expect(page).to have_content("Please enter a zero if the client's partner has no child dependants")
    expect(page).to have_content("Please enter a zero if the client's partner has no child dependants")
  end

  context "with partner dependant numbers" do
    before do
      add_applicant_partner_answers(dependants: true)
      click_on "Save and continue"
      fill_in "Adult dependants", with: "1"
      fill_in "Child dependants", with: "2"
      click_on "Save and continue"
      select_boolean_value("partner-benefits-form", :add_benefit, false)
      click_on "Save and continue"
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
      within "#field-list-partner_details" do
        expect(page).to have_content "Partner has dependants"
      end
      within "#section-partner_details-header" do
        click_on "Change"
      end

      select_boolean_value("partner-details-form", :dependants, false)
      click_on "Save and continue"
      within "#field-list-partner_details" do
        expect(page).to have_content "Partner has dependantsNo"
      end
    end
  end
end
