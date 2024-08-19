require "rails_helper"

RSpec.describe "checks/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data.merge("feature_flags" => feature_flags)) }
  let(:feature_flags) { FeatureFlags.session_flags }

  before do
    assign(:sections, sections)
    assign(:previous_step, Steps::Helper.last_step(session_data))
    params[:assessment_code] = :code
    allow(view).to receive(:form_with)
    render template: "checks/check_answers"
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
                  partner_investments_relevant: true,
                  partner_valuables_relevant: true,
                  partner_investments: 60,
                  partner_valuables: 550)
          end

          it "renders content" do
            expect_in_text(text, [
              "Partner assetsChange",
              "Money in bank account 1£50.00",
              "Money in bank account 2£20.00",
              "Investments£60.00",
              "Valuable items worth £500 or more£550.00",
            ])
          end
        end

        context "when there are no other assets" do
          context "without legacy asset reveals" do
            let(:session_data) do
              build(:minimal_complete_session,
                    :with_conditional_assets,
                    :with_partner,
                    partner_bank_accounts: [{ "amount" => 0 }])
            end

            it "renders content" do
              expect_in_text(page_text_within("#table-partner_assets"), [
                "Partner assetsChange",
                "Money in bank account 1£0.00",
                "Does the partner have any investments?",
                "Does the partner have valuable items worth £500 or more?",
              ])
            end
          end
        end
      end
    end
  end
end
