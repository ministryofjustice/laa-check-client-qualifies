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
    context "when housing benefit" do
      context "when client has housing benefit" do
        let(:session_data) { build(:minimal_complete_session, housing_benefit: true) }

        it "renders content" do
          expect(page_text).to include("Receives Housing BenefitYes")
        end
      end

      context "when client does not have housing benefit" do
        let(:session_data) { build(:minimal_complete_session, housing_benefit: false) }

        it "renders content" do
          expect(page_text).to include("Receives Housing BenefitNo")
        end
      end
    end
  end
end
