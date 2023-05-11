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
        expect(text).to include(t("estimates.check_answers.non_household.about_your_client"))
        expect(text).to include(t("estimates.check_answers.non_household.assets"))
      end

      it "does not render sections" do
        expect(text).not_to include(t("estimates.check_answers.non_household.client_dependant_details"))
        expect(text).not_to include(t("estimates.check_answers.non_household.employment_fields.gross_income"))
        expect(text).not_to include(t("estimates.check_answers.non_household.benefits"))
        expect(text).not_to include(t("estimates.check_answers.non_household.housing_benefit"))
        expect(text).not_to include(t("estimates.check_answers.non_household.other_income"))
      end

      it "renders content" do
        expect(text).to include("Receives a passporting benefitYes")
      end
    end

    context "with a partner who owns the main home" do
      let(:session_data) { build(:minimal_complete_session, :with_partner_owned_main_home, passporting: true) }

      it "renders partner sections" do
        expect(text).to include(t("estimates.check_answers.non_household.about_partner"))
        expect(text).to include(t("estimates.check_answers.non_household.partner_assets"))
      end

      it "does not render partner sections" do
        expect(text).not_to include(t("estimates.check_answers.non_household.partner_dependant_details"))
        expect(text).not_to include(t("estimates.check_answers.non_household.partner_employment_fields.partner_gross_income"))
        expect(text).not_to include(t("estimates.check_answers.non_household.partner_benefits"))
        expect(text).not_to include(t("estimates.check_answers.non_household.partner_housing_benefit"))
        expect(text).not_to include(t("estimates.check_answers.non_household.partner_other_income"))
      end

      it "renders the content" do
        expect(text).to include("Receives a passporting benefitYes")
        expect(text).to include("Has a partnerYes")
        expect(text).to include("Partner employment statusNot provided")
      end
    end
  end
end
