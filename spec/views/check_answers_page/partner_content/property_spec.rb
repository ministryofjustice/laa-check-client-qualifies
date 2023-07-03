require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:answers) { CheckAnswersPresenter.new(session_data) }

  before do
    assign(:answers, answers)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
  end

  describe "partner sections" do
    let(:text) { page_text }

    context "when additional property" do
      let(:additional_house_in_dispute) { false }
      let(:session_data) do
        build(:minimal_complete_session,
              partner: true,
              partner_additional_property_owned:,
              partner_additional_house_value: 100_000,
              partner_additional_mortgage:,
              partner_additional_percentage_owned: 100)
      end

      let(:text) { page_text_within("#field-list-partner_additional_property") }

      context "when owned outright" do
        let(:partner_additional_property_owned) { "outright" }
        let(:partner_additional_mortgage) { nil }

        it "renders content" do
          expect(text).to include("Owns other propertyYes, owned outright")
          expect(text).to include("Estimated value£100,000.00")
          expect(text).to include("Percentage share owned100%")
        end
      end

      context "when partially owned" do
        let(:partner_additional_property_owned) { "with_mortgage" }
        let(:partner_additional_mortgage) { 2_000 }

        it "renders content" do
          expect(text).to include("Owns other propertyYes, with a mortgage or loan")
          expect(text).to include("Estimated value£100,000.00")
          expect(text).to include("Outstanding mortgage£2,000.00")
          expect(text).to include("Percentage share owned100%")
        end
      end
    end
  end
end
