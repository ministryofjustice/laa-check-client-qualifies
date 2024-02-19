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

  describe "partner sections" do
    let(:text) { page_text }

    context "when the partner is unemployed" do
      let(:session_data) do
        build(:minimal_complete_session,
              :with_partner,
              :with_employment,
              partner_employment_status: "unemployed")
      end

      it "renders content" do
        expect(text).to include("What is the partner's employment status?Unemployed")
      end
    end
  end
end
