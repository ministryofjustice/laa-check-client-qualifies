require "rails_helper"

RSpec.shared_context "with certificated other income" do
  before do
    start_assessment
    fill_in_forms_until(:other_income)
  end

  def submit_data_to_cfe
    fill_in "other-income-form-pension-value-field", with: "0"
    fill_in "other-income-form-property-or-lodger-value-field", with: "0"

    fill_in "other-income-form-friends-or-family-value-field", with: "200"
    choose "Every week", name: "other_income_form[friends_or_family_frequency]"

    fill_in "other-income-form-maintenance-value-field", with: "300"
    choose "Every 2 weeks", name: "other_income_form[maintenance_frequency]"

    fill_in "other-income-form-student-finance-value-field", with: "0"
    fill_in "other-income-form-other-value-field", with: "500"

    click_on "Save and continue"
    fill_in_forms_until(:check_answers)
    click_on "Submit"
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
    fill_in "other-income-form-pension-value-field", with: "0"
    fill_in "other-income-form-property-or-lodger-value-field", with: "0"

    fill_in "other-income-form-friends-or-family-value-field", with: "200"
    choose "Every week", name: "other_income_form[friends_or_family_frequency]"

    fill_in "other-income-form-maintenance-value-field", with: "300"
    choose "Every 2 weeks", name: "other_income_form[maintenance_frequency]"

    fill_in "other-income-form-student-finance-value-field", with: "100"
    fill_in "other-income-form-other-value-field", with: "500"

    click_on "Save and continue"
    fill_in_forms_until(:check_answers)
    click_on "Submit"
  end
end

RSpec.describe "Controlled other income", type: :feature do
  context "with stubbing" do
    context "when the check is for certificated work" do
      include_context "with certificated other income"

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

        submit_data_to_cfe
        expect(assessment_stub).to have_been_requested
      end
    end

    context "when the check is for controlled work" do
      include_context "with controlled other income"

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

        submit_data_to_cfe
        expect(assessment_stub).to have_been_requested
      end
    end
  end

  # CFE gives back montlhy figures and ignores frequency (foo[your input value if frequency is weekly] x 52[weeks] / 12[months] = bar[CFE output])
  context "when hitting the API", :end2end do
    context "with certificated" do
      include_context "with certificated other income"

      it "renders content" do
        submit_data_to_cfe
        expect(page).to have_content("Financial help from friends and family\n£866.67")
        expect(page).to have_content("Maintenance payments from a former partner\n£650.00")
        expect(page).to have_content("Income from a property or lodger\n£0.00")
        expect(page).to have_content("Pension\n£0.00")
        expect(page).to have_content("Student finance\n£0.00")
        expect(page).to have_content("Other sources\n£166.67")
      end
    end

    context "with controlled" do
      include_context "with controlled other income"

      it "renders content" do
        submit_data_to_cfe
        expect(page).to have_content("Financial help from friends and family\n£866.67")
        expect(page).to have_content("Maintenance payments from a former partner\n£650.00")
        expect(page).to have_content("Income from a property or lodger\n£0.00")
        expect(page).to have_content("Pension\n£0.00")
        expect(page).to have_content("Student finance\n£100")
        expect(page).to have_content("Other sources\n£500.00")
      end

      it "displays the correct amount for friends and family" do
        submit_data_to_cfe
        expect(page).to have_content("Financial help from friends and family\n£866.67")
      end
    end
  end
end
