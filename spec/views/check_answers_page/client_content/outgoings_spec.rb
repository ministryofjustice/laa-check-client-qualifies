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
    context "when outgoings" do
      context "when multiple outgoings" do
        let(:session_data) do
          build(:minimal_session,
                housing_payments_value: 500,
                housing_payments_frequency: "monthly",
                childcare_payments_value: 300,
                childcare_payments_frequency: "every_four_weeks",
                maintenance_payments_value: 200,
                maintenance_payments_frequency: "every_two_weeks",
                legal_aid_payments_value: 50,
                legal_aid_payments_frequency: "every_week")
        end

        it "renders content" do
          expect(page_text).to include("Housing payments£500.00Monthly")
          expect(page_text).to include("Childcare payments£300.00Every 4 weeks")
          expect(page_text).to include("Maintenance payments£200.00Every 2 weeks")
          expect(page_text).to include("Legal aid payments£50.00Every week")
        end
      end

      context "when no outgoings" do
        let(:session_data) do
          build(:minimal_session,
                housing_payments_value: 0,
                housing_payments_frequency: "",
                childcare_payments_value: 0,
                childcare_payments_frequency: "",
                maintenance_payments_value: 0,
                maintenance_payments_frequency: "",
                legal_aid_payments_value: 0,
                legal_aid_payments_frequency: "")
        end

        it "renders content" do
          expect(page_text).to include("Housing paymentsNot applicable")
          expect(page_text).to include("Childcare paymentsNot applicable")
          expect(page_text).to include("Maintenance paymentsNot applicable")
          expect(page_text).to include("Legal aid paymentsNot applicable")
        end
      end
    end
  end
end
