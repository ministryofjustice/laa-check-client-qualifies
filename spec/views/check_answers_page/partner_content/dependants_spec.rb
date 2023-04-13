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

    context "when there are partner dependants" do
      context "when multiple dependants" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                partner_child_dependants: true,
                partner_child_dependants_count: 1,
                partner_adult_dependants: true,
                partner_adult_dependants_count: 2)
        end

        it "renders content" do
          expect(text).to include("Partner has child dependantsYes")
          expect(text).to include("Number of partner child dependants1")
          expect(text).to include("Partner has adult dependantsYes")
          expect(text).to include("Number of partner adult dependants2")
        end
      end

      context "when no dependants" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                partner_child_dependants: nil,
                partner_adult_dependants: nil)
        end

        it "renders content" do
          expect(text).to include("Partner has child dependantsNo")
          expect(text).to include("Partner has adult dependantsNo")
        end
      end
    end
  end
end
