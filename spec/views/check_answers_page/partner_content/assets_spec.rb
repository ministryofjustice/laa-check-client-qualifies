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
    context "when there are partner assets" do
      context "when they own a vehicle" do
        let(:session_data) do
          build(:minimal_session,
                :with_partner,
                partner_vehicle_owned:,
                partner_vehicle_value:,
                partner_vehicle_pcp:,
                partner_vehicle_finance:,
                partner_vehicle_over_3_years_ago:,
                partner_vehicle_in_regular_use:,
                partner_vehicle_in_dispute:)
        end

        context "when owns vehicle outright" do
          let(:partner_vehicle_owned) { true }
          let(:partner_vehicle_value) { 3_000 }
          let(:partner_vehicle_pcp) { false }
          let(:partner_vehicle_finance) { 0.0 }
          let(:partner_vehicle_over_3_years_ago) { false }
          let(:partner_vehicle_in_regular_use) { false }
          let(:partner_vehicle_in_dispute) { false }

          it "renders content" do
            expect(page_text).to include("Owns a vehicleYes")
            expect(page_text).to include("Estimated value£3,000.00")
            expect(page_text).to include("In regular useNo")
            expect(page_text).to include("Bought over 3 years agoNo")
            expect(page_text).to include("Payments left on vehicleNo")
          end
        end

        context "when they own a vehicle on finance" do
          let(:partner_vehicle_owned) { true }
          let(:partner_vehicle_value) { 2_000 }
          let(:partner_vehicle_pcp) { true }
          let(:partner_vehicle_finance) { 100 }
          let(:partner_vehicle_over_3_years_ago) { true }
          let(:partner_vehicle_in_regular_use) { true }
          let(:partner_vehicle_in_dispute) { false }

          it "renders content" do
            expect(page_text).to include("Owns a vehicleYes")
            expect(page_text).to include("Estimated value£2,000.00")
            expect(page_text).to include("In regular useYes")
            expect(page_text).to include("Bought over 3 years agoYes")
            expect(page_text).to include("Payments left on vehicleYes")
            expect(page_text).to include("Value of payments left£100.00")
          end
        end

        context "when partner does not own vehicle" do
          let(:partner_vehicle_owned) { false }
          let(:partner_vehicle_value) { 0.0 }
          let(:partner_vehicle_pcp) { nil }
          let(:partner_vehicle_finance) { 0.0 }
          let(:partner_vehicle_over_3_years_ago) { nil }
          let(:partner_vehicle_in_regular_use) { nil }
          let(:partner_vehicle_in_dispute) { nil }

          it "renders content" do
            expect(page_text).to include("Owns a vehicleNo")
          end
        end
      end

      context "when partner has other assets" do
        context "when there are multiple other assets" do
          let(:session_data) do
            build(:minimal_session,
                  :with_partner,
                  partner_savings: 50,
                  partner_investments: 60,
                  partner_valuables: 550)
          end

          it "renders content" do
            expect(page_text).to include("Savings£50.00")
            expect(page_text).to include("Investments£60.00")
            expect(page_text).to include("Valuables£550.00")
            expect(page_text).not_to include("Disputed asset")
          end

          context "when there is additional property" do
            let(:session_data) do
              build(:minimal_session,
                    :with_partner,
                    partner_property_value: 100_000,
                    partner_property_mortgage:,
                    partner_property_percentage_owned:)
            end

            context "when owned outright" do
              let(:partner_property_mortgage) { 0 }
              let(:partner_property_percentage_owned) { 100 }

              it "renders content" do
                expect(page_text).to include("Additional property or holiday home: value£100,000.00")
                expect(page_text).to include("Additional property or holiday home: outstanding mortgage£0.00")
                expect(page_text).to include("Additional property or holiday home: % owned100")
              end
            end

            context "when partially owned" do
              let(:partner_property_mortgage) { 2_000 }
              let(:partner_property_percentage_owned) { 50 }

              it "renders content" do
                expect(page_text).to include("Additional property or holiday home: value£100,000.00")
                expect(page_text).to include("Additional property or holiday home: outstanding mortgage£2,000.00")
                expect(page_text).to include("Additional property or holiday home: % owned50")
              end
            end
          end
        end

        context "when there are no other assets" do
          let(:session_data) do
            build(:minimal_session,
                  :with_partner,
                  partner_property_value: 0,
                  partner_property_mortgage: 0,
                  partner_property_percentage_owned: nil,
                  partner_savings: 0,
                  partner_investments: 0,
                  partner_valuables: 0)
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
