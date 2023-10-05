require "rails_helper"

RSpec.describe FeedbacksController, type: :controller do
  describe "#create" do
    it "saves freetext feedback correctly" do
      allow_any_instance_of(described_class).to receive(:level_of_help).and_return("controlled")
      post :create, params: { type: "freetext", text: "foo", page: "bar" }
      expect(FreetextFeedback.find_by(text: "foo", page: "bar", level_of_help: "controlled")).not_to be_nil
    end

    it "saves satisfaction feedback correctly" do
      allow_any_instance_of(described_class).to receive(:level_of_help).and_return("controlled")
      allow_any_instance_of(described_class).to receive(:outcome).and_return("eligible")
      post :create, params: { type: "satisfaction", satisfied: true }
      expect(SatisfactionFeedback.find_by(satisfied: true, level_of_help: "controlled", outcome: "eligible")).not_to be_nil
    end
  end
end
