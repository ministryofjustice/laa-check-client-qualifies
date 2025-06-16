require "rails_helper"

RSpec.describe Steps::OutgoingsSection do
  describe "self.grouped_steps_for(session_data)" do
    let(:session_data) { {} }
    subject(:groups) { described_class.grouped_steps_for(session_data) }

    context "when check is means tested" do
      context "when client does not own property" do
        it "returns the correct outgoings step" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[outgoings]
        end

        it "returns the correct property steps" do
          expect(groups[1].steps).to eq %i[property housing_costs]
        end

        context "when the client has a partner" do
          let(:session_data) { { "partner" => "true" } }

          it "returns the correct outgoings step" do
            expect(groups.count).to eq 3
            expect(groups[0].steps).to eq %i[outgoings]
          end

          it "returns the correct partner outgoings step" do
            expect(groups[1].steps).to eq %i[partner_outgoings]
          end

          it "returns the correct property steps" do
            expect(groups[2].steps).to eq %i[property housing_costs]
          end
        end
      end

      context "when client owns property outright" do
        let(:session_data) { { "property_owned" => "outright" } }

        it "returns the correct outgoings step" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[outgoings]
        end

        it "returns the correct property steps" do
          expect(groups[1].steps).to eq %i[property property_entry]
        end
      end

      context "when client owns property with a mortgage" do
        let(:session_data) { { "property_owned" => "with_mortgage" } }

        it "returns the correct outgoings step" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[outgoings]
        end

        it "returns the correct property steps" do
          expect(groups[1].steps).to eq %i[property mortgage_or_loan_payment property_entry]
        end
      end

      context "when client owns shared_ownership property" do
        let(:session_data) { { "property_owned" => "shared_ownership" } }

        it "returns the correct steps" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[outgoings]
          expect(groups[1].steps).to eq %i[property property_landlord shared_ownership_housing_costs property_entry]
        end
      end
    end

    context "when the check is not means tested" do
      let(:session_data) { { "client_age" => "under_18" } }
      
      it "returns the correct steps" do
        expect(groups.count).to eq 0
      end
    end

    context "when the check is passported" do
      let(:session_data) { { "passporting" => "true" } }

      context "when client does not own property" do 
        it "returns the correct property step" do
          expect(groups.count).to eq 1
          expect(groups[0].steps).to eq %i[property]
        end
      end

      context "when client owns property outright" do
        before { session_data["property_owned"] = "outright" }

        it "returns the correct property steps" do
          expect(groups.count).to eq 1
          expect(groups[0].steps).to eq %i[property property_entry]
        end
      end

      context "when client owns property with a mortgage" do
        before { session_data["property_owned"] = "with_mortgage" }

        it "returns the correct outgoings step" do
          expect(groups.count).to eq 1
          expect(groups[0].steps).to eq %i[property property_entry]
        end
      end

      context "when client owns shared_ownership property" do
        before { session_data["property_owned"] = "shared_ownership" }

        it "returns the correct steps" do
          expect(groups.count).to eq 1
          expect(groups[0].steps).to eq %i[property property_landlord property_entry]
        end
      end
    end
  end
end
