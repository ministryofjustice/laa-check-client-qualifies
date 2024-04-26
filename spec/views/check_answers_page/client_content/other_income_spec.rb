require "rails_helper"

RSpec.describe "checks/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    assign(:previous_step, Steps::Helper.last_step(session_data))
    params[:assessment_code] = :code
    allow(view).to receive(:form_with)
    render template: "checks/check_answers"
  end

  describe "client sections" do
    let(:text) { page_text }

    context "when other income" do
      context "when multiple other incomes" do
        let(:session_data) do
          build(:minimal_complete_session,
                friends_or_family_relevant: true,
                maintenance_relevant: true,
                property_or_lodger_relevant: true,
                pension_relevant: true,
                student_finance_relevant: true,
                other_relevant: true,
                friends_or_family_conditional_value: 50,
                friends_or_family_frequency: "every_week",
                maintenance_conditional_value: 100,
                maintenance_frequency: "every_two_weeks",
                property_or_lodger_conditional_value: 150,
                property_or_lodger_frequency: "every_four_weeks",
                pension_conditional_value: 1_000,
                pension_frequency: "monthly",
                student_finance_conditional_value: 350,
                other_conditional_value: 200)
        end

        it "renders content" do
          expect_in_text(text, [
            "Does your client get financial help from friends or family?Yes£50.00Every week",
            "Does your client get maintenance from a former partner?Yes£100.00Every 2 weeks",
            "Does your client get income from a property or lodger?Yes£150.00Every 4 weeks",
            "Does your client get income from pensions?Yes£1,000.00Monthly",
            "Does your client get income from student finance?Yes£350.00",
            "Does your client get income from other sources?Yes£200.00",
          ])
        end
      end

      context "when no other income" do
        let(:session_data) do
          build(:minimal_complete_session,
                friends_or_family_relevant: false,
                maintenance_relevant: false,
                property_or_lodger_relevant: false,
                pension_relevant: false,
                student_finance_relevant: false,
                other_relevant: false)
        end

        it "renders content" do
          expect_in_text(text, [
            "Does your client get financial help from friends or family?No",
            "Does your client get maintenance from a former partner?No",
            "Does your client get income from a property or lodger?No",
            "Does your client get income from pensions?No",
            "Does your client get income from student finance?No",
            "Does your client get income from other sources?No",
          ])
        end
      end
    end
  end
end
