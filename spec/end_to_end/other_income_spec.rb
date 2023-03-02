require "rails_helper"

RSpec.describe "Controlled other income", type: :feature do
  before do
    stub_request(:post, %r{assessments\z}).to_return(
      body: { assessment_id: "assessment_id" }.to_json,
      headers: { "Content-Type" => "application/json" },
    )
    stub_request(:post, %r{proceeding_types\z})
    stub_request(:post, %r{applicant\z})
    stub_request(:get, %r{assessments/assessment_id\z}).to_return(
      body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
      headers: { "Content-Type" => "application/json" },
    )
  end

  context "when the check is for certificated work" do
    before do
      start_assessment
      fill_in_provider_screen
      fill_in_applicant_screen
      fill_in_dependants_screen
      fill_in_housing_benefit_screen
      fill_in_benefits_screen
    end

    it "sends the right data to CFE for certificated work - in particular ther other income frequency" do
      irregular_transactions = stub_request(:post, %r{irregular_incomes\z}).with do |request|
        expected_payload = {
          payments: [
            { income_type: "unspecified_source", frequency: "quarterly", amount: "500.0" },
          ],
        }
        request.body == expected_payload.to_json
      end

      regular_transactions = stub_request(:post, %r{regular_transactions\z}).with do |request|
        expected_payload = {
          "regular_transactions": [
            { "operation": "credit", "category": "friends_or_family", "frequency": "weekly", "amount": "200.0" },
            { "operation": "credit", "category": "maintenance_in", "frequency": "two_weekly", "amount": "300.0" },
          ],
        }
        request.body == expected_payload.to_json
      end

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

      expect(regular_transactions).to have_been_requested
      expect(irregular_transactions).to have_been_requested
    end
  end

  context "when the check is for controlled work", :controlled_flag do
    before do
      start_assessment
      fill_in_provider_screen
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_applicant_screen
      fill_in_dependants_screen
      fill_in_housing_benefit_screen
      fill_in_benefits_screen
    end

    it "sends the right data to CFE for controlled work - in particular ther other income frequency" do
      irregular_transactions = stub_request(:post, %r{irregular_incomes\z}).with do |request|
        expected_payload = {
          payments: [
            { income_type: "student_loan", frequency: "annual", amount: "100.0" },
            { income_type: "unspecified_source", frequency: "monthly", amount: "500.0" },
          ],
        }
        request.body == expected_payload.to_json
      end

      regular_transactions = stub_request(:post, %r{regular_transactions\z}).with do |request|
        expected_payload = {
          "regular_transactions": [
            { "operation": "credit", "category": "friends_or_family", "frequency": "weekly", "amount": "200.0" },
            { "operation": "credit", "category": "maintenance_in", "frequency": "two_weekly", "amount": "300.0" },
          ],
        }
        request.body == expected_payload.to_json
      end

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

      expect(regular_transactions).to have_been_requested
      expect(irregular_transactions).to have_been_requested
    end
  end
end
