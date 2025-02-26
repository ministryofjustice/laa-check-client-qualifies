require "rails_helper"

RSpec.describe AnalyticsService do
  describe ".call" do
    let(:assessment_code) { "just-another-assessment-code" }

    it "handles errors without crashing", :throws_cfe_error do
      allow(described_class).to receive_messages(valid_event_type?: true, valid_page?: true)
      allow(AnalyticsEvent).to receive(:create!).and_raise(StandardError)
      expect(ErrorService).to receive(:call)

      expect { described_class.call(event_type: "an_event_type", page: "some_page", assessment_code: assessment_code, cookies: {}) }.not_to raise_error
    end

    it "respects no-analytics mode" do
      cookies = { CookiesController::NO_ANALYTICS_MODE => "true" }
      described_class.call(event_type: "an_event_type", page: "some_page", assessment_code: assessment_code, cookies:)
      expect(AnalyticsEvent.count).to eq 0
    end

    it "creates an analytics event for allowlisted page & event_type" do
      cookies = { ApplicationController::BROWSER_ID_COOKIE => "browser123" }
      event_type = "click_lc_guidance_controlled"
      page = "client_age"

      expect {
        described_class.call(
          event_type: event_type,
          page: page,
          assessment_code: assessment_code,
          cookies: cookies,
        )
      }.to change(AnalyticsEvent, :count).by(1)
    end

    it "does not create an analytics event for non-allowlisted page & event_type" do
      cookies = { ApplicationController::BROWSER_ID_COOKIE => "browser123" }
      event_type = "click_lc_guidance_controlled_0'XOR(if(now()=sysdate(),sleep(15),0))XOR'Z"
      page = "not-property_entry"

      expect {
        described_class.call(
          event_type: event_type,
          page: page,
          assessment_code: assessment_code,
          cookies: cookies,
        )
      }.not_to change(AnalyticsEvent, :count)
    end
  end
end
