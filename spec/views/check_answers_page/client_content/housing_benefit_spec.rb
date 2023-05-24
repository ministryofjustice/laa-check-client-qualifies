require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim", :household_section_flag do
  let(:answers) { CheckAnswersPresenter.new(session_data) }

  before do
    assign(:answers, answers)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
  end

  describe "client sections" do
    context "when housing benefit" do
      context "when client has housing benefit" do
        let(:session_data) { build(:minimal_complete_session, housing_benefit_value: 400, housing_benefit_frequency: "every_week") }

        it "renders content" do
          expect(page_text).to include("Housing Benefit amount£400.00Every week")
        end
      end

      context "when client does not have housing benefit" do
        let(:session_data) { build(:minimal_complete_session, housing_benefit_value: 0) }

        it "renders content" do
          expect(page_text).to include("Housing Benefit amount£0.00")
        end
      end
    end
  end
end
