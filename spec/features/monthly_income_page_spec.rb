require "rails_helper"

RSpec.describe "Monthly income Page" do
  let(:income_header) { "What other income does your client receive?" }
  let(:outgoings_header) { "What are your client's outgoings and deductions?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, api_result: CalculationResult.new({}), create_assessment_id: estimate_id) }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    allow(mock_connection).to receive(:create_proceeding_type)
    allow(mock_connection).to receive(:create_regular_payments)
    allow(mock_connection).to receive(:create_applicant)
    visit estimate_build_estimate_path estimate_id, :monthly_income
  end

  it "shows the correct page" do
    expect(page).to have_content income_header
  end

  it "validates presence of a checked field" do
    click_checkbox("monthly-income-form-monthly-incomes", "friends_or_family")
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Financial help from friends and family cannot be blank")
    end
  end

  it "validates that at least one field is checked" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Please select at least one option")
    end
  end

  it "moves onto outgoings with no income" do
    allow(mock_connection).to receive(:create_irregular_income)

    click_checkbox("monthly-income-form-monthly-incomes", "none")
    click_on "Save and continue"
    expect(page).to have_content(outgoings_header)
    progress_to_submit_from_outgoings
  end

  it "handles student finance" do
    payments = [
      {
        "income_type": "student_loan",
        "frequency": "annual",
        "amount": 100,
      },
    ]
    expect(mock_connection).to receive(:create_irregular_income).with(estimate_id, { payments: })

    click_checkbox("monthly-income-form-monthly-incomes", "student_finance")
    fill_in "monthly-income-form-student-finance-field", with: "100"
    click_on "Save and continue"
    expect(page).to have_content(outgoings_header)
    progress_to_submit_from_outgoings
  end

  it "handles non-student finance values and continues to the next screen when page is submitted" do
    payments = [
      {
        "income_type": "unspecified_source_income",
        "frequency": "quarterly",
        "amount": 333,
      },
    ]
    expect(mock_connection).to receive(:create_irregular_income).with(estimate_id, { payments: })
    expect(mock_connection).to receive(:create_regular_payments) do |_estimate_id, model|
      expect(model.friends_or_family).to eq 100
      expect(model.maintenance).to eq 200
      expect(model.property_or_lodger).to eq 300
      expect(model.pension).to eq 400
    end
    click_checkbox("monthly-income-form-monthly-incomes", "friends_or_family")
    fill_in "monthly-income-form-friends-or-family-field", with: "100"
    click_checkbox("monthly-income-form-monthly-incomes", "maintenance")
    fill_in "monthly-income-form-maintenance-field", with: "200"
    click_checkbox("monthly-income-form-monthly-incomes", "property_or_lodger")
    fill_in "monthly-income-form-property-or-lodger-field", with: "300"
    click_checkbox("monthly-income-form-monthly-incomes", "pension")
    fill_in "monthly-income-form-pension-field", with: "400"
    click_checkbox("monthly-income-form-monthly-incomes", "other")
    fill_in "monthly-income-form-other-field", with: "333"
    click_on "Save and continue"
    expect(page).to have_content(outgoings_header)
    progress_to_submit_from_outgoings
  end
end
