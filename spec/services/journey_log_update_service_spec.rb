require "rails_helper"

RSpec.describe JourneyLogUpdateService do
  describe ".call" do
    let(:assessment_id) { "assessment-id" }

    it "handles errors without crashing", :throws_cfe_error do
      expect(ErrorService).to receive(:call)
      allow(CompletedUserJourney).to receive(:find_by!).and_raise "Error!"
      expect { described_class.call(assessment_id, {}, form_downloaded: true) }.not_to raise_error
    end

    it "skips saving in no-analytics mode" do
      expect(ErrorService).not_to receive(:call)
      allow(CompletedUserJourney).to receive(:find_by!).and_raise "Error!"
      expect { described_class.call(assessment_id, { no_analytics_mode: true }, form_downloaded: true) }.not_to raise_error
    end

    context "with new data" do
      it "saves the new details to the database" do
        record = create :completed_user_journey, assessment_id:, form_downloaded: false
        described_class.call(assessment_id, {}, form_downloaded: true)
        expect(record.reload.form_downloaded).to be true
      end
    end
  end
end
