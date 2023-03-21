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
    let(:session_data) { build(:minimal_session, passporting: true) }

    context "without a partner" do
      it "renders sections" do
        expect(page_text).to include(t("estimates.check_answers.about_your_client"))
        expect(page_text).to include(t("estimates.check_answers.assets"))
      end

      it "does not render sections" do
        expect(page_text).not_to include(t("estimates.check_answers.client_dependant_details"))
        expect(page_text).not_to include(t("estimates.check_answers.employment_fields.gross_income"))
        expect(page_text).not_to include(t("estimates.check_answers.benefits"))
        expect(page_text).not_to include(t("estimates.check_answers.housing_benefit"))
        expect(page_text).not_to include(t("estimates.check_answers.other_income"))
      end

      it "renders content" do
        expect(page_text).to include("Receives a passporting benefitYes")
      end
    end

    context "with a partner who owns the main home" do
      let(:session_data) { build(:minimal_session, :with_partner_owned_main_home, passporting: true) }

      it "renders partner sections" do
        expect(page_text).to include(t("estimates.check_answers.about_partner"))
        expect(page_text).to include(t("estimates.check_answers.partner_assets"))
      end

      it "does not render partner sections" do
        expect(page_text).not_to include(t("estimates.check_answers.partner_dependant_details"))
        expect(page_text).not_to include(t("estimates.check_answers.partner_employment_fields.partner_gross_income"))
        expect(page_text).not_to include(t("estimates.check_answers.partner_benefits"))
        expect(page_text).not_to include(t("estimates.check_answers.partner_housing_benefit"))
        expect(page_text).not_to include(t("estimates.check_answers.partner_other_income"))
      end

      it "renders the content" do
        expect(page_text).to include("Receives a passporting benefitYes")
        expect(page_text).to include("Has a partnerYes")
        expect(page_text).to include("Partner employment statusNot provided")
      end
    end
  end
end
