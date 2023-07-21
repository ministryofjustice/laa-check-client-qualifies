require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:answers) { CheckAnswersPresenter.new(session_data) }

  before do
    assign(:answers, answers)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
  end

  describe "client sections: " do
    let(:text) { page_text }

    describe "outgoings: " do
      context "when multiple outgoings" do
        let(:session_data) do
          build(:minimal_complete_session,
                maintenance_payments_value: 200,
                maintenance_payments_frequency: "every_two_weeks",
                legal_aid_payments_value: 50,
                legal_aid_payments_frequency: "every_week")
        end

        it "renders content" do
          expect(text).to include("Maintenance payments£200.00Every 2 weeks")
          expect(text).to include("Legal aid payments£50.00Every week")
        end
      end

      context "when eligible for childcare outgoings" do
        let(:session_data) do
          build(:minimal_complete_session,
                childcare_payments_value: 200,
                childcare_payments_frequency: "every_two_weeks",
                child_dependants: true,
                partner: false,
                student_finance_value: 1)
        end

        it "shows childcare" do
          expect(text).to include("Childcare payments£200.00Every 2 weeks")
        end
      end

      context "when no outgoings" do
        let(:session_data) do
          build(:minimal_complete_session,
                maintenance_payments_value: 0,
                maintenance_payments_frequency: "",
                legal_aid_payments_value: 0,
                legal_aid_payments_frequency: "")
        end

        it "renders content" do
          expect(text).to include("Maintenance payments£0.00")
          expect(text).to include("Legal aid payments£0.00")
        end
      end
    end
  end
end
