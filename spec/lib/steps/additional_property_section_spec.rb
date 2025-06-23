require "rails_helper"

RSpec.describe Steps::AdditionalPropertySection do
  describe "self.grouped_steps_for(session_data)" do
    subject(:groups) { described_class.grouped_steps_for(session_data) }

    let(:session_data) { {} }

    context "when the check is not means tested" do
      let(:session_data) { { "client_age" => "under_18" } }

      it "returns the correct steps" do
        expect(groups.count).to eq 0
      end
    end

    context "when the check is means tested" do
      context "when the client does not own additional property" do
        it "returns the correct additional property steps" do
          expect(groups.count).to eq 1
          expect(groups[0].steps).to eq %i[additional_property]
        end
      end

      context "when the client owns additional property" do
        let(:session_data) { { "additional_property_owned" => "outright" } }

        it "returns the correct additional property steps" do
          expect(groups.count).to eq 1
          expect(groups[0].steps).to eq %i[additional_property additional_property_details]
        end
      end

      context "when the client has a partner" do
        let(:session_data) { { "partner" => "true" } }

        context "when the partner does not own additional property" do
          it "returns the correct additional property steps" do
            expect(groups.count).to eq 2
            expect(groups[0].steps).to eq %i[additional_property]
          end

          it "returns the correct partner additional property steps" do
            expect(groups[1].steps).to eq %i[partner_additional_property]
          end
        end

        context "when the partner owns additional property with a mortgage" do
          before { session_data["partner_additional_property_owned"] = "with_mortgage" }

          it "returns the correct additional property steps" do
            expect(groups.count).to eq 2
            expect(groups[0].steps).to eq %i[additional_property]
          end

          it "returns the correct partner additional property steps" do
            expect(groups[1].steps).to eq %i[partner_additional_property partner_additional_property_details]
          end
        end
      end
    end
  end
end
