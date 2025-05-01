require "rails_helper"

RSpec.describe "migrate:delete_feedback", type: :task do
  let(:feedback_one) { create(:satisfaction_feedback) }
  let(:feedback_two) { create(:satisfaction_feedback) }
  let(:feedback_three) { create(:satisfaction_feedback) }
  let(:mock) { "true" }
  let(:start_date_time) { "2025-04-24 12:05:00" }
  let(:end_date_time) { "2025-04-24 12:15:00" }

  before do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
    Rake::Task["migrate:delete_feedback"].reenable
    feedback_one.update!(created_at: Time.zone.local(2025, 4, 24, 12, 0, 0))
    feedback_two.update!(created_at: Time.zone.local(2025, 4, 24, 12, 10, 0))
    feedback_three.update!(created_at: Time.zone.local(2025, 4, 24, 12, 20, 0))
  end

  describe "migrate:delete_feedback" do
    subject(:task) { Rake::Task["migrate:delete_feedback"] }

    context "when run with mock true" do
      it "does not delete the satisfaction feedbacks" do
        expect(SatisfactionFeedback.count).to eq 3
        expect(Rails.logger).to receive(:info).with("delete_feedback: mock=true, start_date_time=2025-04-24 12:05:00 UTC, end_date_time=2025-04-24 12:15:00 UTC").once
        expect(Rails.logger).to receive(:info).with("delete_feedback: Deleting 1 satisfaction feedbacks").once
        expect(Rails.logger).to receive(:info).with("delete_feedback: 1 satisfaction feedbacks deleted").once
        expect(Rails.logger).to receive(:info).with("delete_feedback: 1 satisfaction feedbacks remaining").once
        task.invoke(mock, start_date_time, end_date_time)
        expect(SatisfactionFeedback.count).to eq 3
      end
    end

    context "when run with mock false" do
      let(:mock) { "false" }

      it "deletes the satisfaction feedbacks" do
        expect(SatisfactionFeedback.count).to eq 3
        expect(Rails.logger).to receive(:info).with("delete_feedback: mock=false, start_date_time=2025-04-24 12:05:00 UTC, end_date_time=2025-04-24 12:15:00 UTC").once
        expect(Rails.logger).to receive(:info).with("delete_feedback: Deleting 1 satisfaction feedbacks").once
        expect(Rails.logger).to receive(:info).with("delete_feedback: 1 satisfaction feedbacks deleted").once
        expect(Rails.logger).to receive(:info).with("delete_feedback: 0 satisfaction feedbacks remaining").once
        task.invoke(mock, start_date_time, end_date_time)
        expect(SatisfactionFeedback.count).to eq 2
      end
    end

    context "when called with the wrong number of arguments" do
      let(:mock) { "false" }

      it "outputs an instruction" do
        expect(Rails.logger).to receive(:info).with("call with rake migrate:delete_feecback[mock, start_date_time, end_date_time]").once
        task.invoke(mock, start_date_time)
      end
    end
  end
end
