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

    context "when there are partner outgoings" do
      context "when there are multiple outgoings" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                partner_maintenance_payments_value: 200,
                partner_maintenance_payments_frequency: "every_two_weeks",
                partner_legal_aid_payments_value: 50,
                partner_legal_aid_payments_frequency: "every_week")
        end

        it "renders content" do
          expect(text).to include("Maintenance payments£200.00Every 2 weeks")
          expect(text).to include("Legal aid payments£50.00Every week")
        end
      end

      context "when eligible for childcare outgoings" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                partner_childcare_payments_value: 200,
                partner_childcare_payments_frequency: "every_two_weeks",
                child_dependants: true,
                partner_student_finance_relevant: true,
                student_finance_relevant: true)
        end

        it "shows childcare" do
          expect(text).to include("Childcare payments£200.00Every 2 weeks")
        end
      end

      context "when there are no outgoings" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                :with_outgoings,
                partner_maintenance_payments_value: 0.0,
                partner_maintenance_payments_frequency: "",
                partner_legal_aid_payments_value: 0.0,
                partner_legal_aid_payments_frequency: "")
        end

        it "renders content" do
          expect(text).to include("Maintenance payments£0.00")
          expect(text).to include("Legal aid payments£0.00")
        end
      end
    end
  end
end
