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

    context "when there are partner outgoings" do
      context "when there are multiple outgoings" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                partner_housing_payments_value: 500,
                partner_housing_payments_frequency: "monthly",
                partner_childcare_payments_value: 300,
                partner_childcare_payments_frequency: "every_four_weeks",
                partner_maintenance_payments_value: 200,
                partner_maintenance_payments_frequency: "every_two_weeks",
                partner_legal_aid_payments_value: 50,
                partner_legal_aid_payments_frequency: "every_week")
        end

        it "renders content" do
          expect(text).to include("Housing payments£500.00Monthly")
          expect(text).to include("Childcare payments£300.00Every 4 weeks")
          expect(text).to include("Maintenance payments£200.00Every 2 weeks")
          expect(text).to include("Legal aid payments£50.00Every week")
        end
      end

      context "when there are no outgoings" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                :with_outgoings,
                partner_housing_payments_value: 0.0,
                partner_housing_payments_frequency: "",
                partner_childcare_payments_value: 0.0,
                partner_childcare_payments_frequency: "",
                partner_maintenance_payments_value: 0.0,
                partner_maintenance_payments_frequency: "",
                partner_legal_aid_payments_value: 0.0,
                partner_legal_aid_payments_frequency: "")
        end

        it "renders content" do
          expect(text).to include("Housing paymentsNot applicable")
          expect(text).to include("Childcare paymentsNot applicable")
          expect(text).to include("Maintenance paymentsNot applicable")
          expect(text).to include("Legal aid paymentsNot applicable")
        end
      end
    end
  end
end
