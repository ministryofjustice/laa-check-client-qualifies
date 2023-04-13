require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:answers) { CheckAnswersPresenter.new(session_data) }

  before do
    assign(:answers, answers)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
  end

  describe "client sections" do
    let(:text) { page_text }

    context "when other benefits" do
      context "when there are multiple other benefits" do
        let(:session_data) do
          build(:minimal_complete_session,
                benefits: [
                  { "id" => "cd858b1f-d90a-4d7e-a1e9-5215f2a15c57",
                    "benefit_type" => "Child Benefit",
                    "benefit_amount" => 100,
                    "benefit_frequency" => "every_two_weeks" },
                  { "id" => "18aeca3f-d2c3-4dbe-97da-f2c495aa19a1",
                    "benefit_type" => "Tax Credit",
                    "benefit_amount" => 50,
                    "benefit_frequency" => "every_week" },
                  { "id" => "32d066d3-4e1c-4702-a00c-bbfb446176f2",
                    "benefit_type" => "State Pension Credit",
                    "benefit_amount" => 40,
                    "benefit_frequency" => "every_four_weeks" },
                  { "id" => "a2edb4ae-68af-4987-ab9e-963358855e94",
                    "benefit_type" => "Incapacity Benefit",
                    "benefit_amount" => 60,
                    "benefit_frequency" => "monthly" },
                ])
        end

        it "renders the correct benefits content" do
          expect(text).to include("Gets other benefitsYes")
          expect(text).to include("Child Benefit£100.00Every 2 weeks")
          expect(text).to include("Tax Credit£50.00Every week")
          expect(text).to include("State Pension Credit£40.00Every 4 weeks")
          expect(text).to include("Incapacity Benefit£60.00Monthly")
        end
      end

      context "when there are no other benefits" do
        let(:session_data) { build(:minimal_complete_session, benefits: []) }

        it "renders content" do
          expect(text).to include("Gets other benefitsNo")
        end
      end
    end
  end
end
