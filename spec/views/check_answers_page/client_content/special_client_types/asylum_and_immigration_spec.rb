require "rails_helper"

RSpec.describe "checks/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    params[:assessment_code] = :code
    allow(view).to receive(:form_with)
    render template: "checks/check_answers"
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
          expect(page_text).to include("Which type of matter is this?Immigration (Upper Tribunal)")
        end
      end

      context "when the provider chooses asylum" do
        let(:matter_type) { "asylum" }

        it "renders the correct case matter type" do
          expect(page_text).to include("Which type of matter is this?Asylum (Upper Tribunal)")
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
          expect(page_text).to include("Is this an immigration or asylum matter?Yes")
          expect(page_text).to include("What type of immigration or asylum matter is this?Immigration - controlled legal representation (CLR) in the First-tier Tribunal")
        end

        context "and asylum support is true" do
          it "renders the correct content" do
            expect(page_text).to include("Does your client get asylum support?Yes")
          end
        end

        context "and asylum support is false" do
          let(:asylum_support) { false }

          it "renders the correct content" do
            expect(page_text).to include("Does your client get asylum support?No")
          end
        end
      end

      context "when provider chooses asylum" do
        let(:immigration_or_asylum_type) { "asylum" }
        let(:asylum_support) { true }

        it "renders the correct case matter type" do
          expect(page_text).to include("Is this an immigration or asylum matter?Yes")
          expect(page_text).to include("What type of immigration or asylum matter is this?Asylum - legal help, help at court, or controlled legal representation (CLR) in the First-tier Tribunal")
        end

        context "and asylum support is true" do
          it "renders the correct content" do
            expect(page_text).to include("Does your client get asylum support?Yes")
          end
        end

        context "and asylum support is false" do
          let(:asylum_support) { false }

          it "renders the correct content" do
            expect(page_text).to include("Does your client get asylum support?No")
          end
        end
      end
    end
  end
end
