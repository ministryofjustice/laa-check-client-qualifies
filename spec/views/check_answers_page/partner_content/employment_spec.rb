require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
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
