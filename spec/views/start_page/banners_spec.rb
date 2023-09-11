require "rails_helper"

RSpec.describe "start/index.html.slim" do
  describe "Banners" do
    context "when there is a live banner" do
      let!(:banner) { create :banner }

      it "shows the banner" do
        render template: "start/index"
        expect(page_text).to include banner.title
        expect(page_text).to include banner.content.to_plain_text.strip
      end
    end
  end

  describe "Issues" do
    context "when there is an active issue" do
      before do
        issue = create :issue, banner_content: "Something has gone wrong."
        create :issue_update, issue:, utc_timestamp: 1.hour.ago
        render template: "start/index"
      end

      it "shows a banner" do
        expect(page_text).to include "A problem has been identified"
        expect(page_text).to include "Something has gone wrong. Learn more."
      end
    end

    context "when there is a recently resolved issue" do
      before do
        issue = create :issue, title: "Problem with Housing Benefit", status: Issue.statuses[:resolved]
        create :issue_update, issue:, utc_timestamp: 1.hour.ago
        render template: "start/index"
      end

      it "shows a banner" do
        expect(page_text).to include "Problem resolved"
        expect(page_text).to include "We have resolved the problem with Housing Benefit. Learn more."
      end
    end
  end
end
