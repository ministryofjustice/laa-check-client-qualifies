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
    let(:text) { page_text }

    context "when other benefits" do
      context "when there are multiple other benefits" do
        let(:session_data) do
          build(:minimal_complete_session,
                receives_benefits: true,
                benefits: [
                  { "benefit_type" => "Child Benefit",
                    "benefit_amount" => 100,
                    "benefit_frequency" => "every_two_weeks" },
                  { "benefit_type" => "Tax Credit",
                    "benefit_amount" => 50,
                    "benefit_frequency" => "every_week" },
                  { "benefit_type" => "State Pension Credit",
                    "benefit_amount" => 40,
                    "benefit_frequency" => "every_four_weeks" },
                  { "benefit_type" => "Incapacity Benefit",
                    "benefit_amount" => 60,
                    "benefit_frequency" => "monthly" },
                ])
        end

        it "renders the correct benefits content" do
          expect_in_text(text, [
            "Does your client get any benefits?Yes",
            "Client benefit 1 details",
            "Benefit nameChild Benefit",
            "Benefit amount£100.00",
            "FrequencyEvery 2 weeks",
            "Client benefit 2 details",
            "Benefit nameTax Credit",
            "Benefit amount£50.00",
            "FrequencyEvery week",
            "Client benefit 3 details",
            "Benefit nameState Pension Credit",
            "Benefit amount£40.00",
            "FrequencyEvery 4 weeks",
            "Client benefit 4 details",
            "Benefit nameIncapacity Benefit",
            "Benefit amount£60.00",
            "FrequencyMonthly",
          ])
        end
      end

      context "when there are no other benefits" do
        let(:session_data) { build(:minimal_complete_session, receives_benefits: false) }

        it "renders content" do
          expect(text).to include("Does your client get any benefits?No")
        end
      end
    end
  end
end
