require "rails_helper"

RSpec.describe "Controlled other income", type: :feature do
  context "when the check is for certificated work" do
    before do
      start_assessment
      fill_in_forms_until(:other_income)
    end

    it "sends the right data to CFE for certificated work - in particular ther other income frequency" do
      assessment_stub = stub_request(:post, %r{v6/assessments\z}).with { |request|
        parsed = JSON.parse(request.body)
        payments = [
          { "income_type" => "unspecified_source", "frequency" => "quarterly", "amount" => 500.0 },
        ]
        regular_transactions = [
          { "operation" => "credit", "category" => "friends_or_family", "frequency" => "weekly", "amount" => 200.0 },
          { "operation" => "credit", "category" => "maintenance_in", "frequency" => "two_weekly", "amount" => 300.0 },
        ]

        parsed.dig("irregular_incomes", "payments") == payments && parsed["regular_transactions"] == regular_transactions
      }.to_return(
        body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
        headers: { "Content-Type" => "application/json" },
      )

      fill_in "other-income-form-pension-value-field", with: "0"
      fill_in "other-income-form-property-or-lodger-value-field", with: "0"

      fill_in "other-income-form-friends-or-family-value-field", with: "200"
      choose "Every week", name: "other_income_form[friends_or_family_frequency]"

      fill_in "other-income-form-maintenance-value-field", with: "300"
      choose "Every 2 weeks", name: "other_income_form[maintenance_frequency]"

      fill_in "other-income-form-student-finance-value-field", with: "0"
      fill_in "other-income-form-other-value-field", with: "500"

      click_on "Save and continue"
      fill_in_outgoings_screen
      fill_in_client_capital_screens
      click_on "Submit"

      expect(assessment_stub).to have_been_requested
    end
  end

  context "when the check is for controlled work" do
    before do
      start_assessment
      fill_in_forms_until(:level_of_help)
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_forms_until(:other_income)
    end

    it "sends the right data to CFE for controlled work - in particular ther other income frequency" do
      assessment_stub = stub_request(:post, %r{v6/assessments\z}).with { |request|
        parsed = JSON.parse(request.body)
        payments = [
          { "income_type" => "student_loan", "frequency" => "annual", "amount" => 100.0 },
          { "income_type" => "unspecified_source", "frequency" => "monthly", "amount" => 500.0 },
        ]
        regular_transactions = [
          { "operation" => "credit", "category" => "friends_or_family", "frequency" => "weekly", "amount" => 200.0 },
          { "operation" => "credit", "category" => "maintenance_in", "frequency" => "two_weekly", "amount" => 300.0 },
        ]
        parsed.dig("irregular_incomes", "payments") == payments && parsed["regular_transactions"] == regular_transactions
      }.to_return(
        body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
        headers: { "Content-Type" => "application/json" },
      )

      fill_in "other-income-form-pension-value-field", with: "0"
      fill_in "other-income-form-property-or-lodger-value-field", with: "0"

      fill_in "other-income-form-friends-or-family-value-field", with: "200"
      choose "Every week", name: "other_income_form[friends_or_family_frequency]"

      fill_in "other-income-form-maintenance-value-field", with: "300"
      choose "Every 2 weeks", name: "other_income_form[maintenance_frequency]"

      fill_in "other-income-form-student-finance-value-field", with: "100"
      fill_in "other-income-form-other-value-field", with: "500"

      click_on "Save and continue"
      fill_in_outgoings_screen
      fill_in_property_screen
      fill_in_assets_screen
      click_on "Submit"

      expect(assessment_stub).to have_been_requested
    end
  end
end
