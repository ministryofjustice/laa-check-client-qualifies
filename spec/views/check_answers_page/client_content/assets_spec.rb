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
    let(:text) { page_text }

    context "when assets" do
      context "when vehicle" do
        let(:session_data) do
          build(:minimal_complete_session,
                vehicle_owned:,
                vehicles: [{
                  vehicle_value:,
                  vehicle_pcp:,
                  vehicle_finance:,
                  vehicle_over_3_years_ago:,
                  vehicle_in_regular_use:,
                  vehicle_in_dispute:,
                }])
        end

        context "when owns vehicle outright" do
          let(:vehicle_owned) { true }
          let(:vehicle_value) { 3_000 }
          let(:vehicle_pcp) { false }
          let(:vehicle_finance) { 0 }
          let(:vehicle_over_3_years_ago) { false }
          let(:vehicle_in_regular_use) { false }
          let(:vehicle_in_dispute) { false }

          it "renders content" do
            expect(text).to include("Client has a vehicleYes")
            expect(text).to include("Estimated value£3,000.00")
            expect(text).to include("In regular useNo")
            expect(text).to include("Bought over 3 years agoNo")
            expect(text).to include("Payments left on vehicleNo")
          end

          context "when is smod" do
            let(:vehicle_in_dispute) { true }

            it "renders content" do
              expect(page_text_within("#field-list-household_vehicles")).to include("Disputed asset")
            end
          end
        end

        context "when owns a vehicle on finance" do
          let(:vehicle_owned) { true }
          let(:vehicle_value) { 2_000 }
          let(:vehicle_pcp) { true }
          let(:vehicle_finance) { 100 }
          let(:vehicle_over_3_years_ago) { true }
          let(:vehicle_in_regular_use) { true }
          let(:vehicle_in_dispute) { false }

          it "renders content correctly" do
            expect(text).to include("Client has a vehicleYes")
            expect(text).to include("Estimated value£2,000.00")
            expect(text).to include("In regular useYes")
            expect(text).to include("Bought over 3 years agoYes")
            expect(text).to include("Payments left on vehicleYes")
            expect(text).to include("Value of payments left£100.00")
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
            expect(text).to include("Client has a vehicleNo")
          end
        end
      end

      context "when other assets" do
        context "when multiple other assets" do
          let(:session_data) do
            build(:minimal_complete_session,
                  savings: 50,
                  investments: 60,
                  valuables: 550,
                  savings_in_dispute:)
          end

          let(:savings_in_dispute) { false }

          it "renders the content correctly" do
            expect(text).to include("Money in bank accounts£50.00")
            expect(text).to include("Investments£60.00")
            expect(text).to include("Valuables£550.00")
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
                  savings: 0,
                  investments: 0,
                  valuables: 0)
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
