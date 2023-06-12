require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:answers) { CheckAnswersPresenter.new(session_data) }

  before do
    assign(:answers, answers)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
  end

  describe "passported client" do
    let(:session_data) { build(:minimal_complete_session, passporting: true) }

    let(:text) { page_text }

    context "without a partner" do
      it "renders sections" do
        expect(text).to include(t("estimates.check_answers.client_details"))
        expect(text).to include(t("estimates.check_answers.assets"))
      end

      it "does not render sections" do
        expect(text).not_to include(t("estimates.check_answers.client_pay_fields.gross_income"))
        expect(text).not_to include(t("estimates.check_answers.benefits"))
        expect(text).not_to include(t("estimates.check_answers.other_income"))
      end

      it "renders content" do
        expect(text).to include("Receives a passporting benefitYes")
      end
    end

    context "with a partner" do
      let(:session_data) { build(:minimal_complete_session, partner: true, passporting: true) }

      it "renders partner sections" do
        expect(text).to include(t("estimates.check_answers.partner_details"))
        expect(text).to include(t("estimates.check_answers.partner_assets"))
      end

      it "does not render partner sections" do
        expect(text).not_to include(t("estimates.check_answers.partner_pay_fields.partner_gross_income"))
        expect(text).not_to include(t("estimates.check_answers.partner_benefits"))
        expect(text).not_to include(t("estimates.check_answers.partner_other_income"))
      end

      it "renders the content" do
        expect(text).to include("Receives a passporting benefitYes")
        expect(text).to include("Has a partnerYes")
      end
    end
  end
end
