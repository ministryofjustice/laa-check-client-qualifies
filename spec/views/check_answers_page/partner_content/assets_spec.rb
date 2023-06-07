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

    context "when there are partner assets" do
      context "when partner has other assets" do
        context "when there are multiple other assets" do
          let(:session_data) do
            build(:minimal_complete_session,
                  :with_partner,
                  partner_savings: 50,
                  partner_investments: 60,
                  partner_valuables: 550)
          end

          it "renders content" do
            expect(text).to include("Money in bank accounts£50.00")
            expect(text).to include("Investments£60.00")
            expect(text).to include("Valuables£550.00")
            expect(text).not_to include("Disputed asset")
          end
        end

        context "when there are no other assets" do
          let(:session_data) do
            build(:minimal_complete_session,
                  :with_partner,
                  partner_savings: 0,
                  partner_investments: 0,
                  partner_valuables: 0)
          end

          it "renders content" do
            expect(text).to include("Money in bank accounts£0.00")
            expect(text).to include("Investments£0.00")
            expect(text).to include("Valuables£0.00")
          end
        end
      end
    end
  end
end
