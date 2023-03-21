require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:answers) { CheckAnswersPresenter.new(session_data) }

  before do
    assign(:answers, answers)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
  end

  describe "immigration and asylum proceedings", :asylum_and_immigration_flag do
    let(:session_data) do
      build(:minimal_session,
            level_of_help: "controlled",
            legacy_proceeding_type: nil,
            proceeding_type:,
            asylum_support:)
    end

    context "when provider chooses immigration first tier tribunal" do
      let(:proceeding_type) { "IM030" }
      let(:asylum_support) { true }

      it "renders the correct case matter type" do
        expect(page_text).to include("Type of matterImmigration in the Upper Tribunal")
      end

      context "and asylum support is true" do
        it "renders the correct content" do
          expect(page_text).to include("Receives asylum supportYes")
        end
      end

      context "and asylum support is false" do
        let(:asylum_support) { false }

        it "renders the correct content" do
          expect(page_text).to include("Receives asylum supportNo")
        end
      end
    end

    context "when provider chooses asylum in first tier tribunal" do
      let(:proceeding_type) { "IA031" }
      let(:asylum_support) { true }

      it "renders the correct case matter type" do
        expect(page_text).to include("Type of matterAsylum in the Upper Tribunal")
      end

      context "and asylum support is true" do
        it "renders the correct content" do
          expect(page_text).to include("Receives asylum supportYes")
        end
      end

      context "and asylum support is false" do
        let(:asylum_support) { false }

        it "renders the correct content" do
          expect(page_text).to include("Receives asylum supportNo")
        end
      end
    end
  end
end
