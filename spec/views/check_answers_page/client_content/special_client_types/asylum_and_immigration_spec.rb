require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:answers) { CheckAnswersPresenter.new(session_data) }

  before do
    assign(:answers, answers)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
  end

  describe "immigration and asylum proceedings" do
    let(:session_data) do
      build(:minimal_complete_session,
            level_of_help:,
            matter_type:,
            asylum_support:)
    end

    context "when the level of help is certificated" do
      let(:session_data) do
        build(:minimal_complete_session,
              level_of_help: "certificated",
              matter_type:)
      end

      context "when the provider chooses immigration" do
        let(:matter_type) { "immigration" }

        it "renders the correct case matter type" do
          expect(page_text).to include("Type of matterImmigration in the Upper Tribunal")
        end
      end

      context "when the provider chooses asylum" do
        let(:matter_type) { "asylum" }

        it "renders the correct case matter type" do
          expect(page_text).to include("Type of matterAsylum in the Upper Tribunal")
        end
      end
    end

    context "when the level of help is controlled" do
      let(:session_data) do
        build(:minimal_complete_session,
              level_of_help: "controlled",
              immigration_or_asylum: true,
              immigration_or_asylum_type:,
              asylum_support:)
      end

      context "when provider chooses immigration" do
        let(:immigration_or_asylum_type) { "immigration_clr" }
        let(:asylum_support) { true }

        it "renders the correct case matter type" do
          expect(page_text).to include("Type of matterImmigration – CLR in the First-tier Tribunal")
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

      context "when provider chooses asylum" do
        let(:immigration_or_asylum_type) { "asylum" }
        let(:asylum_support) { true }

        it "renders the correct case matter type" do
          expect(page_text).to include("Type of matterAsylum")
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
end
