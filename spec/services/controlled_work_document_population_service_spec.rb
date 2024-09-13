require "rails_helper"

RSpec.describe ControlledWorkDocumentPopulationService do
  describe ".generate_form_key" do
    # rubocop:disable RSpec/VerifiedDoubles
    let(:model) { double(described_class) }
    # rubocop:enable RSpec/VerifiedDoubles

    context "when form_type is cw1 and language is welsh" do
      before do
        allow(model).to receive_messages(form_type: "cw1", language: "welsh")
      end

      it "returns cw1_welsh" do
        expect(described_class.generate_form_key(model)).to eq("cw1_welsh")
      end
    end

    context "when form_type is cw1 and feature flag cw_form_updates is enabled" do
      before do
        allow(model).to receive_messages(form_type: "cw1", language: "english")
        allow(FeatureFlags).to receive(:enabled?).with(:cw_form_updates, without_session_data: true).and_return(true)
      end

      it "returns cw1_new" do
        expect(described_class.generate_form_key(model)).to eq("cw1_new")
      end
    end

    context "when form_type is cw1_welsh and feature flag cw_form_updates is enabled", :cw_form_updates_flag do
      before do
        allow(FeatureFlags).to receive(:enabled?).with(:cw_form_updates, without_session_data: true).and_return(true)
        allow(model).to receive_messages(form_type: "cw1", language: "welsh")
      end

      it "returns cw1_welsh_new" do
        expect(described_class.generate_form_key(model)).to eq("cw1_welsh_new")
      end
    end
  end
end
