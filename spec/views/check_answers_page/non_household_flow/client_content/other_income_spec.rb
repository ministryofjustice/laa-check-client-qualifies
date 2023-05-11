require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:answers) { CheckAnswersPresenter.new(session_data) }

  before do
    assign(:answers, answers)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
  end

  describe "client sections" do
    let(:text) { page_text }

    context "when other income" do
      context "when multiple other incomes" do
        let(:session_data) do
          build(:minimal_complete_session,
                friends_or_family_value: 50,
                friends_or_family_frequency: "every_week",
                maintenance_value: 100,
                maintenance_frequency: "every_two_weeks",
                property_or_lodger_value: 150,
                property_or_lodger_frequency: "every_four_weeks",
                pension_value: 1_000,
                pension_frequency: "monthly",
                student_finance_value: 350,
                other_value: 200)
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

      context "when no other income" do
        let(:session_data) do
          build(:minimal_complete_session,
                friends_or_family_value: 0,
                friends_or_family_frequency: "",
                maintenance_value: 0,
                maintenance_frequency: "",
                property_or_lodger_value: 0,
                property_or_lodger_frequency: "",
                pension_value: 0,
                pension_frequency: "",
                student_finance_value: 0,
                other_value: 0)
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
