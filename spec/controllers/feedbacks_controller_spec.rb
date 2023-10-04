require "rails_helper"

RSpec.describe FeedbacksController, type: :controller do
  describe "#create" do
    it "saves freetext feedback correctly" do
      post :create, params: { type: "freetext", feedback: { text: "foo", page: "bar" } }
      expect(FreetextFeedback.find_by(text: "foo", page: "bar")).not_to be_nil
    end

    it "saves satisfaction feedback to the database" do
      post :create, params: { satisfied: true, level_of_help: "controlled", outcome: "eligible", widget_type: "satisfaction" }
      expect(SatisfactionFeedback.find_by(satisfied: true, level_of_help: "controlled", outcome: "eligible")).not_to be_nil
    end

    it "errors if feedback text is blank" do
    end

    it "raises error if satisfaction outcome is invalid" do
      post :create, params: { satisfied: true, level_of_help: "controlled", outcome: "foo", widget_type: "satisfaction" }
      expect(SatisfactionFeedback.find_by(satisfied: true, level_of_help: "controlled", outcome: "foo")).to be_nil
      expect(response).to raise_error
    end
  end
end
