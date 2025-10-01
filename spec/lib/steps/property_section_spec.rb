require "rails_helper"

RSpec.describe Steps::PropertySection do
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
      context "when client does not own property" do
        it "returns the correct property steps" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[property housing_costs]
        end

        it "returns the correct additional property step" do
          expect(groups[1].steps).to eq %i[additional_property]
        end

        context "when the client has a partner" do
          let(:session_data) { { "partner" => "true" } }

          it "returns the correct property steps" do
            expect(groups.count).to eq 3
            expect(groups[0].steps).to eq %i[property housing_costs]
          end

          it "returns the correct additional property step" do
            expect(groups[1].steps).to eq %i[additional_property]
          end

          it "returns the correct partner additional property steps" do
            expect(groups[2].steps).to eq %i[partner_additional_property]
          end
        end
      end

      context "when client owns property outright" do
        let(:session_data) { { "property_owned" => "outright" } }

        it "returns the correct property steps" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[property property_entry]
        end

        it "returns the correct additional property step" do
          expect(groups[1].steps).to eq %i[additional_property]
        end
      end

      context "when client owns property with a mortgage" do
        let(:session_data) { { "property_owned" => "with_mortgage" } }

        it "returns the correct property steps" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[property mortgage_or_loan_payment property_entry]
        end

        it "returns the correct additional property step" do
          expect(groups[1].steps).to eq %i[additional_property]
        end
      end

      context "when client owns shared_ownership property" do
        let(:session_data) { { "property_owned" => "shared_ownership" } }

        it "returns the correct property steps" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[property property_landlord shared_ownership_housing_costs property_entry]
        end

        it "returns the correct additional property step" do
          expect(groups[1].steps).to eq %i[additional_property]
        end
      end
    end

    context "when the client owns additional property" do
      let(:session_data) { { "additional_property_owned" => "outright" } }

      it "returns the correct property steps" do
        expect(groups.count).to eq 2
        expect(groups[0].steps).to eq %i[property housing_costs]
      end

      it "returns the correct additional property steps" do
        expect(groups[1].steps).to eq %i[additional_property additional_property_details]
      end
    end

    context "when the partner owns additional property with a mortgage" do
      let(:session_data) { { "partner" => "true" } }

      before { session_data["partner_additional_property_owned"] = "with_mortgage" }

      it "returns the correct property steps" do
        expect(groups.count).to eq 3
        expect(groups[0].steps).to eq %i[property housing_costs]
      end

      it "returns the correct additional property steps" do
        expect(groups[1].steps).to eq %i[additional_property]
      end

      it "returns the correct partner additional property steps" do
        expect(groups[2].steps).to eq %i[partner_additional_property partner_additional_property_details]
      end
    end

    context "when the check is passported" do
      let(:session_data) { { "passporting" => "true" } }

      context "when client does not own property" do
        it "returns the correct property step" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[property]
        end

        it "returns the correct additional property step" do
          expect(groups[1].steps).to eq %i[additional_property]
        end
      end

      context "when client owns property outright" do
        before { session_data["property_owned"] = "outright" }

        it "returns the correct property steps" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[property property_entry]
        end

        it "returns the correct additional property step" do
          expect(groups[1].steps).to eq %i[additional_property]
        end
      end

      context "when client owns property with a mortgage" do
        before { session_data["property_owned"] = "with_mortgage" }

        it "returns the correct propert steps" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[property property_entry]
        end

        it "returns the correct additional property step" do
          expect(groups[1].steps).to eq %i[additional_property]
        end
      end

      context "when client owns shared_ownership property" do
        before { session_data["property_owned"] = "shared_ownership" }

        it "returns the correct property steps" do
          expect(groups.count).to eq 2
          expect(groups[0].steps).to eq %i[property property_landlord property_entry]
        end

        it "returns the correct additional property step" do
          expect(groups[1].steps).to eq %i[additional_property]
        end
      end
    end
  end
end
