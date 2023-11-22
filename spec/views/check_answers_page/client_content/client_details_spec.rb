require "rails_helper"

RSpec.describe "checks/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    params[:assessment_code] = :code
    allow(view).to receive(:form_with)
    render template: "checks/check_answers"
  end

  describe "client details" do
    let(:session_data) { build(:minimal_complete_session, passporting: true) }

    let(:text) { page_text }

    it "renders client details" do
      within "#table-applicant" do
        expect(text).to include("Is your client aged 60 or over?")
        expect(text).to include("Does your client have a partner?")
        expect(text).to include("Does your client receive a passporting benefit?")
      end
    end

    context "when under-18 flag is enabled", :under_eighteen_flag do
      it "renders client details without over-60 question" do
        within "#table-applicant" do
          expect(text).not_to include("Is your client aged 60 or over?")
        end
      end
    end
  end
end
