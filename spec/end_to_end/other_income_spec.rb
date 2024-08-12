require "rails_helper"

RSpec.shared_context "with certificated other income" do
  before do
    start_assessment
    fill_in_forms_until(:other_income)
  end

  def submit_data_to_cfe
    choose "Yes", name: "other_income_form[friends_or_family_relevant]"
    choose "Yes", name: "other_income_form[maintenance_relevant]"
    choose "No", name: "other_income_form[property_or_lodger_relevant]"
    choose "No", name: "other_income_form[pension_relevant]"
    choose "No", name: "other_income_form[student_finance_relevant]"
    choose "Yes", name: "other_income_form[other_relevant]"

    fill_in "other-income-form-friends-or-family-conditional-value-field", with: "200"
    choose "Every week", name: "other_income_form[friends_or_family_frequency]"

    fill_in "other-income-form-maintenance-conditional-value-field", with: "300"
    choose "Every 2 weeks", name: "other_income_form[maintenance_frequency]"

    fill_in "other-income-form-other-conditional-value-field", with: "500"

    click_on "Save and continue"
    fill_in_forms_until(:check_answers)
  end
end

RSpec.shared_context "with controlled other income" do
  before do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_forms_until(:other_income)
  end

  def submit_data_to_cfe
    choose "Yes", name: "other_income_form[friends_or_family_relevant]"
    choose "Yes", name: "other_income_form[maintenance_relevant]"
    choose "No", name: "other_income_form[property_or_lodger_relevant]"
    choose "No", name: "other_income_form[pension_relevant]"
    choose "Yes", name: "other_income_form[student_finance_relevant]"
    choose "Yes", name: "other_income_form[other_relevant]"

    fill_in "other-income-form-friends-or-family-conditional-value-field", with: "200"
    choose "Every week", name: "other_income_form[friends_or_family_frequency]"

    fill_in "other-income-form-maintenance-conditional-value-field", with: "300"
    choose "Every 2 weeks", name: "other_income_form[maintenance_frequency]"

    fill_in "other-income-form-student-finance-conditional-value-field", with: "100"

    fill_in "other-income-form-other-conditional-value-field", with: "500"

    click_on "Save and continue"
    fill_in_forms_until(:check_answers)
  end
end

RSpec.describe "Other income", type: :feature do
  context "with stubbing", :stub_cfe_calls_with_webmock do
    context "when the check is for certificated work" do
      include_context "with certificated other income"
      before do
        submit_data_to_cfe
        WebMock.reset!
      end

      it "sends the right data to CFE for certificated work - in particular the other income frequency" do
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

        click_on "Submit"
        expect(assessment_stub).to have_been_requested
      end
    end

    context "when the check is for controlled work" do
      include_context "with controlled other income"
      before do
        submit_data_to_cfe
        WebMock.reset!
      end

      it "sends the right data to CFE for controlled work - in particular the other income frequency" do
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

        click_on "Submit"
        expect(assessment_stub).to have_been_requested
      end
    end
  end

  # CFE gives back figures which have been converted to monthly figures (foo[your input value] x 52[weeks - if frequency is weekly] / 12[months] = bar[CFE output])
  context "when hitting the API", :end2end do
    context "with certificated" do
      include_context "with certificated other income"

      it "renders content" do
        submit_data_to_cfe
        click_on "Submit"
        expect(page).to have_content("Financial help from friends and family\n£866.67")
        expect(page).to have_content("Maintenance payments from a former partner\n£650.00")
        expect(page).to have_content("Income from a property or lodger\n£0.00")
        expect(page).to have_content("Pensions\n£0.00")
        expect(page).to have_content("Student finance\n£0.00")
        expect(page).to have_content("Other sources\n£166.67")
      end
    end

    context "with controlled" do
      include_context "with controlled other income"

      it "renders content" do
        submit_data_to_cfe
        click_on "Submit"
        expect(page).to have_content("Financial help from friends and family\n£866.67")
        expect(page).to have_content("Maintenance payments from a former partner\n£650.00")
        expect(page).to have_content("Income from a property or lodger\n£0.00")
        expect(page).to have_content("Pensions\n£0.00")
        expect(page).to have_content("Student finance\n£8.33")
        expect(page).to have_content("Other sources\n£500.00")
      end
    end
  end
end
