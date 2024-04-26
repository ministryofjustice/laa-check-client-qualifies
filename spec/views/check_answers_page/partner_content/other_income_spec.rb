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

  describe "partner sections" do
    let(:text) { page_text }

    context "when there is partner other income" do
      context "when there are multiple other incomes" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                partner_friends_or_family_relevant: true,
                partner_maintenance_relevant: true,
                partner_property_or_lodger_relevant: true,
                partner_pension_relevant: true,
                partner_student_finance_relevant: true,
                partner_other_relevant: true,
                partner_friends_or_family_conditional_value: 50,
                partner_friends_or_family_frequency: "every_week",
                partner_maintenance_conditional_value: 100,
                partner_maintenance_frequency: "every_two_weeks",
                partner_property_or_lodger_conditional_value: 150,
                partner_property_or_lodger_frequency: "every_four_weeks",
                partner_pension_conditional_value: 1_000,
                partner_pension_frequency: "monthly",
                partner_student_finance_conditional_value: 350,
                partner_other_conditional_value: 200)
        end

        it "renders content" do
          expect_in_text(text, [
            "Does the partner get financial help from friends or family?Yes£50.00Every week",
            "Does the partner get maintenance from a former partner?Yes£100.00Every 2 weeks",
            "Does the partner get income from a property or lodger?Yes£150.00Every 4 weeks",
            "Does the partner get income from pensions?Yes£1,000.00Monthly",
            "Does the partner get income from student finance?Yes£350.00",
            "Does the partner get income from other sources?Yes£200.00",
            # "Financial help from friends or family£50.00Every week",
            # "Maintenance payments from a former partner£100.00Every 2 weeks",
            # "Income from a property or lodger£150.00Every 4 weeks",
            # "Pensions£1,000.00Monthly",
            # "Student finance£350.00",
            # "Income from other sources£200.00",
          ])
        end
      end

      context "when there is no other partner income" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                :with_other_income,
                partner_friends_or_family_relevant: false,
                partner_maintenance_relevant: false,
                partner_property_or_lodger_relevant: false,
                partner_pension_relevant: false,
                partner_student_finance_relevant: false,
                partner_other_relevant: false)
        end

        it "renders content" do
          expect_in_text(page_text_within("#table-partner_other_income"), [
            "Does the partner get financial help from friends or family?No",
            "Does the partner get maintenance from a former partner?No",
            "Does the partner get income from a property or lodger?No",
            "Does the partner get income from pensions?No",
            "Does the partner get income from student finance?No",
            "Does the partner get income from other sources?No",
          ])
        end
      end
    end
  end
end
