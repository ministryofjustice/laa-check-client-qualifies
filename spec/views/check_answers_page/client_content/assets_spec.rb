require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
  end

  describe "client sections" do
    let(:text) { page_text }

    context "when assets" do
      context "when vehicle" do
        let(:session_data) do
          build(:minimal_complete_session,
                vehicle_owned:,
                vehicles: [{
                  "vehicle_value" => vehicle_value,
                  "vehicle_pcp" => vehicle_pcp,
                  "vehicle_finance" => vehicle_finance,
                  "vehicle_over_3_years_ago" => vehicle_over_3_years_ago,
                  "vehicle_in_regular_use" => vehicle_in_regular_use,
                  "vehicle_in_dispute" => vehicle_in_dispute,
                }])
        end

        context "when owns vehicle outright" do
          let(:vehicle_owned) { true }
          let(:vehicle_value) { 3_000 }
          let(:vehicle_pcp) { false }
          let(:vehicle_finance) { 0 }
          let(:vehicle_over_3_years_ago) { true }
          let(:vehicle_in_regular_use) { true }
          let(:vehicle_in_dispute) { false }

          it "renders content" do
            expect_in_text(text, [
              "Does your client own a vehicle?Yes",
              "Vehicle 1 detailsChange",
              "What is the estimated value of the vehicle?£3,000.00",
              "Are there any payments left on the vehicle?No",
              "Was the vehicle bought over 3 years ago?Yes",
              "Is the vehicle in regular use?Yes",
            ])
          end

          context "when is smod" do
            let(:vehicle_in_dispute) { true }

            it "renders content" do
              expect(page_text_within("#table-vehicles_details")).to include("Disputed asset")
            end
          end
        end

        context "when owns a vehicle on finance" do
          let(:vehicle_owned) { true }
          let(:vehicle_value) { 2_000 }
          let(:vehicle_pcp) { true }
          let(:vehicle_finance) { 100 }
          let(:vehicle_over_3_years_ago) { false }
          let(:vehicle_in_regular_use) { false }
          let(:vehicle_in_dispute) { false }

          it "renders content correctly" do
            expect_in_text(text, [
              "Does your client own a vehicle?Yes",
              "Vehicle 1 detailsChange",
              "What is the estimated value of the vehicle?£2,000.00",
              "Are there any payments left on the vehicle?Yes",
              "Value of payments left£100.00",
              "Was the vehicle bought over 3 years ago?No",
              "Is the vehicle in regular use?No",
            ])
          end
        end

        context "when does not own vehicle" do
          let(:vehicle_owned) { false }
          let(:vehicle_value) { 0 }
          let(:vehicle_pcp) { nil }
          let(:vehicle_finance) { 0 }
          let(:vehicle_over_3_years_ago) { nil }
          let(:vehicle_in_regular_use) { nil }
          let(:vehicle_in_dispute) { nil }

          it "renders content" do
            expect(text).to include("Does your client own a vehicle?No")
          end
        end
      end

      context "when other assets" do
        context "when multiple other assets" do
          let(:session_data) do
            build(:minimal_complete_session,
                  bank_accounts: [
                    { "amount" => 50, "account_in_dispute" => savings_in_dispute },
                    { "amount" => 30, "account_in_dispute" => savings_in_dispute },
                  ],
                  investments: 60,
                  valuables: 550)
          end

          let(:savings_in_dispute) { false }

          it "renders the content correctly" do
            expect_in_text(text, [
              "Client assetsChange",
              "Money in bank accounts£50.00",
              "Additional bank account 1£30.00",
              "Investments£60.00",
              "Valuable items worth £500 or more£550.00",
            ])
          end

          context "when is smod" do
            let(:savings_in_dispute) { true }

            it "renders content" do
              expect(page_text_within("#money-in-bank-accounts")).to include("Disputed asset")
            end
          end
        end

        context "when no other assets" do
          let(:session_data) do
            build(:minimal_complete_session,
                  bank_accounts: [{ "amount" => 0 }],
                  investments: 0,
                  valuables: 0)
          end

          it "renders content" do
            expect_in_text(text, [
              "Client assetsChange",
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
