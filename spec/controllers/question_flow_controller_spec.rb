require "rails_helper"

RSpec.describe QuestionFlowController, type: :controller do
  let(:controller) { described_class.new.tap { |c| c.params = params } }

  describe "#assessment_code" do
    context "when an assessment_code param is present" do
      let(:params) { { assessment_code: "abc123", resource_id: "ignored" } }

      it "returns the assessment_code param" do
        expect(controller.send(:assessment_code)).to eq "abc123"
      end
    end

    context "when the assessment_code param is blank" do
      let(:params) { { assessment_code: "" } }

      it "returns nil" do
        expect(controller.send(:assessment_code)).to be_nil
      end
    end
  end
end
