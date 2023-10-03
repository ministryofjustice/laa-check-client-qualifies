require "rails_helper"

RSpec.describe FeedbacksController, type: :controller do
  describe "#new" do
  end

  describe "#create" do
    it "saves freetext feedback to the database" do
      post :create, params: { text: "some text", level_of_help: "controlled", page: "foo", widget_type: "bar" }
      expect(FreetextFeedback.find_by(text: "some text", level_of_help: "controlled", page: "foo")).not_to be_nil
    end

    it "saves satisfaction feedback to the database" do
      post :create, params: { satisfied: true, level_of_help: "controlled", outcome: "eligible", widget_type: "satisfaction" }
      expect(SatisfactionFeedback.find_by(satisfied: true, level_of_help: "controlled", outcome: "eligible")).not_to be_nil
    end

    it "errors if feedback text is blank" do
    end

    it "raises error if satisfaction outcome is invalid" do
    end
  end
end
