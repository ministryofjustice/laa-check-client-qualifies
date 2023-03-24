require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:answers) { CheckAnswersPresenter.new(session_data) }

  before do
    assign(:answers, answers)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
  end

  describe "partner sections" do
    let(:text) { page_text }

    context "when there is partner other income" do
      context "when there are multiple other incomes" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                partner_friends_or_family_value: 50,
                partner_friends_or_family_frequency: "every_week",
                partner_maintenance_value: 100,
                partner_maintenance_frequency: "every_two_weeks",
                partner_property_or_lodger_value: 150,
                partner_property_or_lodger_frequency: "every_four_weeks",
                partner_pension_value: 1_000,
                partner_pension_frequency: "monthly",
                partner_student_finance_value: 350,
                partner_other_value: 200)
        end

        it "renders content" do
          expect(text).to include("Financial help£50.00Every week")
          expect(text).to include("Maintenance payments from a former partner£100.00Every 2 weeks")
          expect(text).to include("Income from a property or lodger£150.00Every 4 weeks")
          expect(text).to include("Pension£1,000.00Monthly")
          expect(text).to include("Student finance£350.00")
          expect(text).to include("Other sources£200.00")
        end
      end

      context "when there is no other partner income" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                :with_other_income,
                partner_friends_or_family_value: 0.0,
                partner_friends_or_family_frequency: "",
                partner_maintenance_value: 0.0,
                partner_maintenance_frequency: "",
                partner_property_or_lodger_value: 0.0,
                partner_property_or_lodger_frequency: "",
                partner_pension_value: 0.0,
                partner_pension_frequency: "",
                partner_student_finance_value: 0.0,
                partner_other_value: 0.0)
        end

        it "renders content" do
          expect(text).to include("Financial helpNot applicable")
          expect(text).to include("Maintenance payments from a former partnerNot applicable")
          expect(text).to include("Income from a property or lodgerNot applicable")
          expect(text).to include("PensionNot applicable")
          expect(text).to include("Student finance£0.00")
          expect(text).to include("Other sources£0.00")
        end
      end
    end
  end
end
