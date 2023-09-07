require "rails_helper"

RSpec.describe "checks/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    params[:assessment_code] = :code
    allow(view).to receive(:form_with)
    render template: "checks/check_answers"
  end

  describe "client sections" do
    let(:text) { page_text }

    context "when dependants" do
      context "when multiple dependants" do
        let(:session_data) do
          build(:minimal_complete_session,
                child_dependants: true,
                child_dependants_count: 1,
                adult_dependants: true,
                adult_dependants_count: 2)
        end

        it "renders content" do
          expect_in_text(text, [
            "Does your client have any child dependants?Yes",
            "How many child dependants are there?1",
            "Does your client have any adult dependants?Yes",
            "How many adult dependants are there?2",
          ])
        end
      end

      context "when no dependants" do
        let(:session_data) do
          build(:minimal_complete_session,
                child_dependants: nil,
                adult_dependants: nil)
        end

        it "renders content" do
          expect_in_text(text, [
            "Does your client have any child dependants?No",
            "Does your client have any adult dependants?No",
          ])
        end
      end
    end
  end
end
