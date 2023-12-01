require "rails_helper"

RSpec.describe "feedback requests" do
  let(:response_json) { JSON.parse(response.body) }

  describe "PATCH /feedbacks/X" do
    it "does not allow updating of records not created by the same user" do
      feedback = create(:satisfaction_feedback, comment: nil)
      patch("/feedbacks/#{feedback.id}", params: { comment: "Fake news" })
      expect(response).not_to be_successful
      expect(feedback.reload.comment).to be_nil
    end
  end
end
