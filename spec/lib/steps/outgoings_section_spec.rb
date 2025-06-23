require "rails_helper"

RSpec.describe Steps::OutgoingsSection do
  describe "self.grouped_steps_for(session_data)" do
    subject(:groups) { described_class.grouped_steps_for(session_data) }

    let(:session_data) { {} }

    context "when check is means tested" do
      it "returns the correct outgoings step" do
        expect(groups.count).to eq 1
        expect(groups[0].steps).to eq %i[outgoings]
      end

      context "when the client has a partner" do
        let(:session_data) { { "partner" => "true" } }

        it "returns the correct outgoings step" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[outgoings]
        end

        it "returns the correct partner outgoings steps" do
          expect(groups[1].steps).to eq %i[partner_outgoings]
        end
      end
    end

    context "when the check is not means tested" do
      let(:session_data) { { "client_age" => "under_18" } }

      it "returns the correct steps" do
        expect(groups.count).to eq 0
      end
    end
  end
end
