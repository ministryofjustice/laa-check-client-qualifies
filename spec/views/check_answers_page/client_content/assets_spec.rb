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
    context "when assets" do
      context "when vehicle" do
        let(:session_data) do
          build(:minimal_session,
                vehicle_owned:,
                vehicle_value:,
                vehicle_pcp:,
                vehicle_finance:,
                vehicle_over_3_years_ago:,
                vehicle_in_regular_use:,
                vehicle_in_dispute:)
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
            expect(page_text).to include("Owns a vehicleYes")
            expect(page_text).to include("Estimated value£3,000.00")
            expect(page_text).to include("In regular useNo")
            expect(page_text).to include("Bought over 3 years agoNo")
            expect(page_text).to include("Payments left on vehicleNo")
          end

          context "when is smod" do
            let(:vehicle_in_dispute) { true }

            it "renders content" do
              expect(page_text).to include("Disputed asset")
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
            expect(page_text).to include("Owns a vehicleYes")
            expect(page_text).to include("Estimated value£2,000.00")
            expect(page_text).to include("In regular useYes")
            expect(page_text).to include("Bought over 3 years agoYes")
            expect(page_text).to include("Payments left on vehicleYes")
            expect(page_text).to include("Value of payments left£100.00")
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
            expect(page_text).to include("Owns a vehicleNo")
          end
        end
      end

      context "when other assets" do
        context "when multiple other assets" do
          let(:session_data) do
            build(:minimal_session,
                  savings: 50,
                  investments: 60,
                  valuables: 550,
                  in_dispute:)
          end

          let(:in_dispute) { [] }

          it "renders the content correctly" do
            expect(page_text).to include("Savings£50.00")
            expect(page_text).to include("Investments£60.00")
            expect(page_text).to include("Valuables£550.00")
            expect(page_text).not_to include("Disputed asset")
          end

          context "when is smod" do
            let(:in_dispute) { %w[savings investments valuables] }

            it "renders content" do
              expect(page_text).to include("Disputed asset")
              expect(page_text.scan(/(?=Disputed asset)/).count).to eq(3)
            end
          end

          context "when additional property" do
            let(:session_data) do
              build(:minimal_session,
                    property_value: 100_000,
                    property_mortgage:,
                    property_percentage_owned:,
                    in_dispute:)
            end

            let(:in_dispute) { [] }

            context "when owned outright" do
              let(:property_mortgage) { 0 }
              let(:property_percentage_owned) { 100 }

              it "renders content" do
                expect(page_text).to include("Additional property or holiday home: value£100,000.00")
                expect(page_text).to include("Additional property or holiday home: outstanding mortgage£0.00")
                expect(page_text).to include("Additional property or holiday home: % owned100")
                expect(page_text).not_to include("Disputed asset")
              end

              context "when smod" do
                let(:in_dispute) { %w[property] }

                it "renders content" do
                  expect(page_text).to include("Disputed asset")
                end
              end
            end

            context "when partially owned" do
              let(:property_mortgage) { 2_000 }
              let(:property_percentage_owned) { 50 }

              it "renders content" do
                expect(page_text).to include("Additional property or holiday home: value£100,000.00")
                expect(page_text).to include("Additional property or holiday home: outstanding mortgage£2,000.00")
                expect(page_text).to include("Additional property or holiday home: % owned50")
                expect(page_text).not_to include("Disputed asset")
              end
            end
          end
        end

        context "when no other assets" do
          let(:session_data) do
            build(:minimal_session,
                  property_value: 0,
                  property_mortgage: 0,
                  property_percentage_owned: nil,
                  savings: 0,
                  investments: 0,
                  valuables: 0)
          end

          it "renders content" do
            expect(page_text).to include("Savings£0.00")
            expect(page_text).to include("Investments£0.00")
            expect(page_text).to include("Valuables£0.00")
            expect(page_text).to include("Additional property or holiday home: value£0.00")
            expect(page_text).to include("Additional property or holiday home: outstanding mortgage£0.00")
            expect(page_text).to include("Additional property or holiday home: % ownedNot applicable")
          end
        end
      end
    end
  end
end
