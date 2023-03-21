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
    context "when there is housing benefit information" do
      context "when partner has housing benefit" do
        let(:session_data) do
          build(:minimal_session,
                :with_partner,
                housing_benefit: false,
                partner_housing_benefit: true)
        end

        it "renders content" do
          expect(page_text).to include("Receives housing benefitYes")
        end
      end

      context "when partner does not have housing benefit" do
        let(:session_data) do
          build(:minimal_session,
                :with_partner,
                housing_benefit: false,
                partner_housing_benefit: false)
        end

        it "renders content" do
          expect(page_text).to include("Receives housing benefitNo")
        end
      end
    end
  end
end
