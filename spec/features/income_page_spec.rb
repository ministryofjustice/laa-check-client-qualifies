require "rails_helper"

RSpec.describe "Income Page" do
  let(:income_header) { "What income does your client receive?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    visit "/estimates/new"
    select_applicant_boolean(:over_60, false)
    select_applicant_boolean(:dependants, false)
    select_applicant_boolean(:partner, false)
    select_applicant_boolean(:employed, false)

    select_applicant_boolean(:passporting, false)
    click_on "Save and continue"
  end

  it "shows the correct page" do
    expect(page).to have_content income_header
  end

  it "validates presence of a checked field" do
    click_checkbox("monthly-income-form-monthly-incomes", "employment_income")
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page).to have_content("can't be blank")
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
    expect(mock_connection).to receive(:create_student_loan).with(estimate_id, nil)
    expect(mock_connection)
      .to receive(:create_regular_payments)

    click_checkbox("monthly-income-form-monthly-incomes", "none")
    click_on "Save and continue"
    expect(page).to have_content("What are your client's monthly outgoings and deductions?")
  end

  it "handles student finance" do
    expect(mock_connection).to receive(:create_student_loan).with(estimate_id, 100)
    expect(mock_connection)
      .to receive(:create_regular_payments)

    click_checkbox("monthly-income-form-monthly-incomes", "student_finance")
    fill_in "monthly-income-form-student-finance-field", with: "100"
    click_on "Save and continue"
  end

  it "handles friends or family and maintenance" do
    expect(mock_connection).to receive(:create_student_loan).with(estimate_id, nil)
    expect(mock_connection)
      .to receive(:create_regular_payments)
    # .with(estimate_id,
    #       [{ amount: 200,
    #          category: :friends_or_family,
    #          frequency: :monthly,
    #          operation: :credit },
    #        { amount: 300,
    #          category: :maintenance_in,
    #          frequency: :monthly,
    #          operation: :credit }])

    click_checkbox("monthly-income-form-monthly-incomes", "friends_or_family")
    fill_in "monthly-income-form-friends-or-family-field", with: "200"
    click_checkbox("monthly-income-form-monthly-incomes", "maintenance")
    fill_in "monthly-income-form-maintenance-field", with: "300"
    click_on "Save and continue"
  end
end
