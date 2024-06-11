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

  describe "client sections" do
    context "when client has housing benefit" do
      context "with conditional reveals" do
        let(:session_data) do
          build(:minimal_complete_session,
                housing_benefit_relevant: true, housing_benefit_value: 400, housing_benefit_frequency: "every_week")
        end

        it "renders content" do
          expect(page_text).to include("Is Housing Benefit claimed at the home the client lives in?Yes")
          expect(page_text).to include("Housing Benefit£400.00Every week")
        end
      end

      context "without conditional reveals", :legacy_assets_no_reveal do
        let(:session_data) { build(:minimal_complete_session, housing_benefit_value: 400, housing_benefit_frequency: "every_week") }

        it "renders content" do
          expect(page_text).not_to include("Is Housing Benefit claimed at the home the client lives in?Yes")
          expect(page_text).to include("Housing Benefit£400.00Every week")
        end
      end
    end

    context "when client does not have housing benefit" do
      context "with conditional reveals" do
        let(:session_data) { build(:minimal_complete_session, housing_payments: 0, housing_benefit_relevant: false) }

        it "renders content" do
          expect(page_text).to include("Is Housing Benefit claimed at the home the client lives in?No")
          expect(page_text).not_to include("Housing Benefit£0.00")
        end
      end

      context "without conditional reveals", :legacy_assets_no_reveal do
        let(:session_data) { build(:minimal_complete_session, housing_payments: 0, housing_benefit_value: 0) }

        it "renders content" do
          expect(page_text).not_to include("Is Housing Benefit claimed at the home the client lives in?No")
          expect(page_text).to include("Housing Benefit£0.00")
        end
      end
    end
  end
end
