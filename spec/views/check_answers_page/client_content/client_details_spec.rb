require "rails_helper"

RSpec.describe "checks/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    assign(:previous_step, Steps::Helper.last_step(session_data))
    params[:assessment_code] = :code
    allow(view).to receive(:form_with)
    render template: "checks/check_answers"
  end

  describe "client details" do
    let(:session_data) { build(:minimal_complete_session, passporting: true) }

    let(:text) { page_text }

    it "renders client details" do
      within "#table-applicant" do
        expect(text).not_to include("Is your client aged 60 or over?")
        expect(text).to include("Does your client have a partner?")
        expect(text).to include("Does your client receive a passporting benefit?")
      end
    end
  end
end
