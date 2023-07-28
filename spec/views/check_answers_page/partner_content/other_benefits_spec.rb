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

    context "when there are other partner benefits" do
      context "when there are multiple other benefits" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                benefits: [],
                partner_receives_benefits: true,
                partner_benefits: [
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

        it "renders content" do
          expect_in_text(text, [
            "Does the partner get any benefits?Yes",
            "Partner benefit 1 details",
            "Benefit nameChild Benefit",
            "Benefit amount£100.00",
            "FrequencyEvery 2 weeks",
            "Partner benefit 2 details",
            "Benefit nameTax Credit",
            "Benefit amount£50.00",
            "FrequencyEvery week",
            "Partner benefit 3 details",
            "Benefit nameState Pension Credit",
            "Benefit amount£40.00",
            "FrequencyEvery 4 weeks",
            "Partner benefit 4 details",
            "Benefit nameIncapacity Benefit",
            "Benefit amount£60.00",
            "FrequencyMonthly",
          ])
        end
      end

      context "when there are no other partner benefits" do
        let(:session_data) { build(:minimal_complete_session, :with_partner, benefits: [], partner_benefits: []) }

        it "renders content" do
          expect(text).to include("Does the partner get any benefits?No")
        end
      end
    end
  end
end
