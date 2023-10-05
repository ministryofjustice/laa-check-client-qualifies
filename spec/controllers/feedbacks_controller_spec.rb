require "rails_helper"

RSpec.describe FeedbacksController, type: :controller do
  describe "#create" do
    before do
      allow(controller).to receive(:level_of_help).and_return("controlled")
    end

    it "saves freetext feedback correctly" do
      post :create, params: { type: "freetext", text: "foo", page: "bar" }
      expect(FreetextFeedback.find_by(text: "foo", page: "bar", level_of_help: "controlled")).not_to be_nil
    end

    it "saves satisfaction feedback correctly" do
      allow(controller).to receive(:outcome).and_return("eligible")
      post :create, params: { type: "satisfaction", satisfied: "yes" }
      expect(SatisfactionFeedback.find_by(satisfied: "yes", level_of_help: "controlled", outcome: "eligible")).not_to be_nil
    end

    it "raise error when no feedback type is entered" do
      expect { post :create, params: { type: nil, satisfied: "yes" } }.to raise_error("Feedback type needs to be specified")
    end

    it "raise error when an invalid feedback type is entered" do
      expect { post :create, params: { type: "foo", text: "bar", page: "some page" } }.to raise_error("Feedback type needs to be specified")
    end
  end
end
