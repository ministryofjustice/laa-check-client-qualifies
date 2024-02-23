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

  describe "Level of help sidebar" do
    context "when the work is controlled" do
      let(:session_data) { build(:minimal_complete_session, level_of_help: "controlled") }

      it "renders correct help text" do
        expect(page_text).to include("Civil controlled work or family mediation")
      end
    end

    context "when the work is certificated" do
      let(:session_data) { build(:minimal_complete_session, level_of_help: "certificated") }

      it "renders correct help text" do
        expect(page_text).to include("Civil certificated or licensed legal work")
      end
    end
  end
end
