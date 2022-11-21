require "rails_helper"

RSpec.describe "Dependants" do
  let(:estimate_id) { SecureRandom.uuid }
  let(:benefits_page_header) { I18n.t("estimate_flow.benefits.legend") }
  let(:mock_connection) do
    instance_double(CfeConnection,
                    create_assessment_id: nil,
                    create_proceeding_type: nil,
                    create_benefits: nil,
                    create_irregular_income: nil,
                    create_regular_payments: nil,
                    create_applicant: nil,
                    api_result: calculation_result)
  end
  let(:calculation_result) { CalculationResult.new(FactoryBot.build(:api_result)) }
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 10, 17, 9, 0, 0) }

  before do
    travel_to arbitrary_fixed_time
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    visit estimate_build_estimate_path(estimate_id, :dependants)
  end

  it "checks I have made a choice" do
    click_on("Save and continue")
    expect(page).to have_content("Select yes if the client has any dependants")
  end

  it "allows me to skip past the details screen" do
    select_boolean_value("dependants-form", :dependants, false)
    click_on("Save and continue")
    expect(page).to have_content(benefits_page_header)
  end

  it "requires me to enter dependants if I say I have them" do
    select_boolean_value("dependants-form", :dependants, true)
    click_on "Save and continue"
    click_on "Save and continue"
    expect(page).to have_content("Please enter a zero if the client has no child dependants")
    expect(page).to have_content("Please enter a zero if the client has no adult dependants")
  end

  it "allows me to enter dependant numberss and passes them on to CFE" do
    select_boolean_value("dependants-form", :dependants, true)
    click_on "Save and continue"
    fill_in "Adult dependants", with: "1"
    fill_in "Child dependants", with: "2"
    click_on "Save and continue"

    expect(mock_connection).to receive(:create_dependants) do |_estimate_id, params|
      expect(params.count { _1[:date_of_birth] < 18.years.ago }).to eq 1
      expect(params.count { _1[:date_of_birth] > 18.years.ago }).to eq 2
    end

    progress_to_submit_from_benefits
  end
end
