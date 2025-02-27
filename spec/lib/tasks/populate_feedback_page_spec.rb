require "rails_helper"

RSpec.describe "migrate:populate_feedback_page", type: :task do
  before do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
  end

  describe "migrate:populate_feedback_pages" do
    subject(:task) { Rake::Task["migrate:populate_feedback_pages"] }

    it "updates the satisfaction feedback page" do
      controlled_satisfaction_feedback = create(:satisfaction_feedback, level_of_help: "controlled")
      certificated_satisfaction_feedback = create(:satisfaction_feedback, level_of_help: "certificated")
      expect(Rails.logger).to receive(:info).with("populate_feedback_pages: Updating 2 satisfaction feedback pages").once
      expect(Rails.logger).to receive(:info).with("populate_feedback_pages: 2 satisfaction feedback pages updated").once
      expect(Rails.logger).to receive(:info).with("populate_feedback_pages: 0 blank satisfaction feedback pages remaining").once
      task.execute
      expect(controlled_satisfaction_feedback.reload.page).to eq "end_of_journey_checks"
      expect(certificated_satisfaction_feedback.reload.page).to eq "show_results"
    end
  end
end
