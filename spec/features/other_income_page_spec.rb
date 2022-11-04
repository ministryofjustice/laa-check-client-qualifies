require "rails_helper"

RSpec.describe "Other income Page" do
  let(:income_header) { "What other income does your client receive?" }
  let(:outgoings_header) { "What are your client's outgoings and deductions?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) do
    instance_double(CfeConnection,
                    api_result: CalculationResult.new({}),
                    create_assessment_id: nil,
                    create_proceeding_type: nil,
                    create_applicant: nil)
  end

  before do
    visit estimate_build_estimate_path(estimate_id, :other_income)
  end

  it "shows the correct page" do
    expect(page).to have_content income_header
  end

  context "when I put in valid values" do
    before do
      fill_in "other-income-form-pension-value-field", with: "34"
      select_radio_value("other-income-form", "pension-frequency", "monthly")

      fill_in "other-income-form-property-or-lodger-value-field", with: "45"
      select_radio_value("other-income-form", "property-or-lodger-frequency", "every-week")

      fill_in "other-income-form-friends-or-family-value-field", with: "200"
      select_radio_value("other-income-form", "friends-or-family-frequency", "every-week")

      fill_in "other-income-form-maintenance-value-field", with: "300"
      select_radio_value("other-income-form", "maintenance-frequency", "every-two-weeks")

      fill_in "other-income-form-student-finance-value-field", with: "100"
      fill_in "other-income-form-other-value-field", with: "67"

      click_on "Save and continue"
    end

    it "allows me to proceed" do
      expect(page).to have_content("What are your client's outgoings and deductions?")
    end

    it "shows correctly on check answers" do
      skip_outgoings_form
      skip_property_form
      skip_vehicle_form
      skip_assets_form
      within "#field-list-other_income" do
        expect(page).to have_content "Financial help\n£200.00"
        expect(page).to have_content "Maintenance payments from a former partner\n£300.00"
        expect(page).to have_content "Student finance£100.00"
        expect(page).to have_content "Income from a property or lodger\n£45.00"
        expect(page).to have_content "Pension\n£34.00"
        expect(page).to have_content "Other sources£67.00"
      end
    end
  end

  it "validates if value fields are left blank" do
    click_on "Save and continue"
    expect(page).to have_content("Please enter a zero if your client receives no income from friends or family")
    expect(page).to have_content("Please enter a zero if your client receives no maintenance payments")
    expect(page).to have_content("Please enter a zero if your client receives no income from a property or lodger")
    expect(page).to have_content("Please enter a zero if your client receives no income from a pension")
    expect(page).to have_content("Please enter a zero if your client receives no student finance")
    expect(page).to have_content("Please enter a zero if your client receives no other income")
  end

  it "validates if value fields are entered above zero and frequencies aren't" do
    fill_in "other-income-form-pension-value-field", with: "0"
    fill_in "other-income-form-property-or-lodger-value-field", with: "100"
    fill_in "other-income-form-friends-or-family-value-field", with: "200"
    fill_in "other-income-form-maintenance-value-field", with: "300"
    fill_in "other-income-form-student-finance-value-field", with: "0"
    fill_in "other-income-form-other-value-field", with: "0"
    click_on "Save and continue"
    expect(page).to have_content("Please enter the frequency of your client's friends or family income")
    expect(page).to have_content("Please enter the frequency of your client's maintenance payments")
    expect(page).to have_content("Please enter the frequency of your client's property or lodger income")
    expect(page).not_to have_content("Please enter the frequency of your client's pension income")
  end

  it "sends the right data to CFE" do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)

    expect(mock_connection).to receive(:create_regular_payments) do |_cfe_estimate_id, payments|
      credit_payments = payments.select { _1[:operation] == :credit }
      expect(credit_payments.length).to eq 2
      expect(credit_payments.find { _1[:category] == :friends_or_family }[:frequency]).to eq(:weekly)
      expect(credit_payments.find { _1[:category] == :friends_or_family }[:amount]).to eq(200)
      expect(credit_payments.find { _1[:category] == :maintenance_in }[:frequency]).to eq(:two_weekly)
      expect(credit_payments.find { _1[:category] == :maintenance_in }[:amount]).to eq(300)
    end
    expect(mock_connection).to receive(:create_irregular_income) do |_cfe_estimate_id, payments|
      expect(payments.length).to eq 2
      expect(payments.find { _1[:income_type] == "unspecified_source" }[:frequency]).to eq("quarterly")
      expect(payments.find { _1[:income_type] == "unspecified_source" }[:amount]).to eq(500)
      expect(payments.find { _1[:income_type] == "student_loan" }[:frequency]).to eq("annual")
      expect(payments.find { _1[:income_type] == "student_loan" }[:amount]).to eq(100)
    end

    fill_in "other-income-form-pension-value-field", with: "0"
    fill_in "other-income-form-property-or-lodger-value-field", with: "0"

    fill_in "other-income-form-friends-or-family-value-field", with: "200"
    select_radio_value("other-income-form", "friends-or-family-frequency", "every-week")

    fill_in "other-income-form-maintenance-value-field", with: "300"
    select_radio_value("other-income-form", "maintenance-frequency", "every-two-weeks")

    fill_in "other-income-form-student-finance-value-field", with: "100"
    fill_in "other-income-form-other-value-field", with: "500"

    click_on "Save and continue"
    progress_to_submit_from_outgoings
  end
end
