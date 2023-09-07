require "rails_helper"

RSpec.describe "checks/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    params[:assessment_code] = :code
    allow(view).to receive(:form_with)
    render template: "checks/check_answers"
  end

  describe "partner sections" do
    let(:text) { page_text }

    context "when additional property" do
      let(:additional_house_in_dispute) { false }
      let(:session_data) do
        build(:minimal_complete_session,
              partner: true,
              partner_additional_property_owned:,
              partner_additional_properties: [{
                "house_value" => 100_000,
                "percentage_owned" => 100,
                "mortgage" => partner_additional_mortgage,
                "house_in_dispute" => true,
              }])
      end

      let(:text) { page_text_within("#field-list-partner_additional_property") }

      context "when owned outright" do
        let(:partner_additional_property_owned) { "outright" }
        let(:partner_additional_mortgage) { nil }

        it "renders content" do
          expect(page_text_within("#table-partner_additional_property")).to include(
            "Does the partner own any other property, a holiday home or land?Yes, owned outright",
          )

          expect_in_text(page_text_within("#table-partner_additional_property_details"), [
            "Partner other property 1 details",
            "How much is the property, holiday home or land worth?£100,000.00",
            "What percentage does the partner own?100%",
          ])
        end
      end

      context "when partially owned" do
        let(:partner_additional_property_owned) { "with_mortgage" }
        let(:partner_additional_mortgage) { 2_000 }

        it "renders content" do
          expect(page_text_within("#table-partner_additional_property")).to include(
            "Does the partner own any other property, a holiday home or land?Yes, with a mortgage or loan",
          )

          expect_in_text(page_text_within("#table-partner_additional_property_details"), [
            "Partner other property 1 details",
            "How much is the property, holiday home or land worth?£100,000.00",
            "Value of outstanding mortgage£2,000.00",
            "What percentage does the partner own?100%",
          ])
        end
      end
    end
  end
end
