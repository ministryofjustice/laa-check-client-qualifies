require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
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
                  partner_bank_accounts: [{ "amount" => 50 }, { "amount" => 20 }],
                  partner_investments: 60,
                  partner_valuables: 550)
          end

          it "renders content" do
            expect_in_text(text, [
              "Partner assetsChange",
              "Money in bank accounts£50.00",
              "Additional bank account 1£20.00",
              "Investments£60.00",
              "Valuable items worth £500 or more£550.00",
            ])
          end
        end

        context "when there are no other assets" do
          let(:session_data) do
            build(:minimal_complete_session,
                  :with_partner,
                  partner_bank_accounts: [{ "amount" => 0 }],
                  partner_investments: 0,
                  partner_valuables: 0)
          end

          it "renders content" do
            expect_in_text(page_text_within("#table-partner_assets"), [
              "Partner assetsChange",
              "Money in bank accounts£0.00",
              "Investments£0.00",
              "Valuable items worth £500 or more£0.00",
            ])
          end
        end
      end
    end
  end
end
