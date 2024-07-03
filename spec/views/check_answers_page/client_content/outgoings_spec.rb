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

  describe "client sections:" do
    let(:text) { page_text }

    describe "outgoings:" do
      context "when multiple outgoings" do
        let(:session_data) do
          build(:minimal_complete_session,
                maintenance_payments_relevant: true,
                maintenance_payments_conditional_value: 200,
                maintenance_payments_frequency: "every_two_weeks",
                legal_aid_payments_relevant: true,
                legal_aid_payments_conditional_value: 50,
                legal_aid_payments_frequency: "every_week")
        end

        it "renders content" do
          expect(text).to include("Does your client pay maintenance to a former partner?Yes£200.00Every 2 weeks")
          expect(text).to include("Does your client make payments toward legal aid for a criminal case?Yes£50.00Every week")
        end
      end

      context "when eligible for childcare outgoings" do
        let(:session_data) do
          build(:minimal_complete_session,
                childcare_payments_relevant: true,
                childcare_payments_conditional_value: 200,
                childcare_payments_frequency: "every_two_weeks",
                child_dependants: true,
                partner: false,
                student_finance_relevant: true)
        end

        it "shows childcare" do
          expect(text).to include("Does your client pay for childcare?Yes£200.00Every 2 weeks")
        end
      end

      context "when no outgoings" do
        let(:session_data) do
          build(:minimal_complete_session,
                maintenance_payments_relevant: false,
                legal_aid_payments_relevant: false)
        end

        it "renders content" do
          expect(text).to include("Does your client pay maintenance to a former partner?No")
          expect(text).to include("Does your client make payments toward legal aid for a criminal case?No")
        end
      end
    end
  end
end
