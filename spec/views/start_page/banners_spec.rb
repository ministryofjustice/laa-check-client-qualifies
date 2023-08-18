require "rails_helper"

RSpec.describe "start/index.html.slim" do
  describe "Change logs" do
    context "when the dependant allowance change log is not yet to be displayed" do
      before do
        travel_to "2023-4-1"
        render template: "start/index"
      end

      let(:content) { page_text }

      it "shows no banner" do
        expect(content).not_to include "On 10 April 2023 some allowances"
      end
    end

    context "when the change log is to be displayed but not live" do
      before do
        travel_to "2023-4-4"
        render template: "start/index"
      end

      let(:content) { page_text }

      it "shows a banner with future-looking text" do
        expect(content).to include "On 10 April 2023 some allowances used to estimate if a client is likely to meet the financial criteria for legal aid will change"
      end
    end

    context "when the change log is only just live" do
      before do
        travel_to "2023-4-10"
        render template: "start/index"
      end

      let(:content) { page_text }

      it "shows a banner with backward-looking text" do
        expect(content).to include "On 10 April 2023 some allowances used to estimate if a client is likely to meet the financial criteria for legal aid changed"
      end
    end

    context "when the change log has been live for a while" do
      before do
        travel_to "2023-5-5"
        render template: "start/index"
      end

      let(:content) { page_text }

      it "shows no banner" do
        expect(content).not_to include "On 10 April 2023 some allowances"
      end
    end
  end

  describe "Issues" do
    context "when there is an active issue" do
      before do
        issue = Issue.create! banner_content: "Something has gone wrong.", status: Issue.statuses[:active]
        IssueUpdate.create! issue:, published_at: 1.hour.ago
        render template: "start/index"
      end

      it "shows a banner" do
        expect(page_text).to include "A problem has been identified"
        expect(page_text).to include "Something has gone wrong. Learn more."
      end
    end

    context "when there is a recently resolved issue" do
      before do
        issue = Issue.create! title: "Problem with Housing Benefit", status: Issue.statuses[:resolved]
        IssueUpdate.create! issue:, published_at: 1.hour.ago
        render template: "start/index"
      end

      it "shows a banner" do
        expect(page_text).to include "Problem resolved"
        expect(page_text).to include "We have resolved the problem with Housing Benefit. Learn more."
      end
    end
  end
end
