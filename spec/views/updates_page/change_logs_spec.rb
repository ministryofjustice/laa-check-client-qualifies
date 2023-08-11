require "rails_helper"

RSpec.describe "updates/index.html.slim" do
  describe "Change logs" do
    context "when the dependant allowance change log is not yet to be displayed" do
      before do
        travel_to "2023-4-1"
        render template: "updates/index"
      end

      let(:content) { page_text }

      it "shows nothing in the history" do
        expect(content).not_to include "10 April 2023Changes to dependant and partner allowance"
      end
    end

    context "when the change log is to be displayed but not live" do
      before do
        travel_to "2023-4-4"
        render template: "updates/index"
      end

      let(:content) { page_text }

      it "shows nothing in the history" do
        expect(content).not_to include "10 April 2023Changes to dependant and partner allowance"
      end
    end

    context "when the change log is only just live" do
      before do
        travel_to "2023-4-10"
        render template: "updates/index"
      end

      let(:content) { page_text }

      it "shows an item in the history" do
        expect(content).to include "10 April 2023Changes to dependant and partner allowance"
      end
    end

    context "when the change log has been live for a while" do
      before do
        travel_to "2023-5-5"
        render template: "updates/index"
      end

      let(:content) { page_text }

      it "shows an item in the history" do
        expect(content).to include "10 April 2023Changes to dependant and partner allowance"
      end
    end
  end
end
