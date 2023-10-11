require "rails_helper"

RSpec.describe FeedbacksController, type: :controller do
  describe "#create" do
    let(:session) do
      { "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4" =>
                      { "level_of_help" => "controlled",
                        "api_response" =>
                        { "result_summary" => { "overall_result" => { "result" => "eligible" } } } } }
    end

    it "saves freetext feedback correctly" do
      post :create, session:, params: { assessment_code: "1234", type: "freetext", text: "foo", page: "bar" }
      expect(FreetextFeedback.find_by(text: "foo", page: "bar", level_of_help: "controlled")).not_to be_nil
    end

    it "saves satisfaction feedback correctly" do
      post :create, session:, params: { assessment_code: "1234", type: "satisfaction", satisfied: "yes" }
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
