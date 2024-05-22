require "rails_helper"

RSpec.describe "checks/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    travel_to Date.new 2024, 3, 12
    assign(:sections, sections)
    assign(:previous_step, Steps::Helper.last_step(session_data))
    params[:assessment_code] = :code
    allow(view).to receive(:form_with)
    render template: "checks/check_answers"
  end

  describe "client sections" do
    let(:text) { page_text }

    context "when property" do
      context "when home is owned with a mortgage or loan" do
        let(:session_data) do
          build(:minimal_complete_session,
                property_owned: "with_mortgage",
                house_value: 200_000,
                mortgage: 5_000,
                percentage_owned: 50,
                house_in_dispute:)
        end

        let(:house_in_dispute) { false }

        it "renders content" do
          expect_in_text(text, [
            "Does your client own the home the client lives in?Yes, with a mortgage or loan",
            "Home client lives in detailsChange",
            "Estimated value£200,000.00",
            "Outstanding mortgage£5,000.00",
            "Percentage share owned50%",
          ])
        end

        context "when is smod" do
          let(:house_in_dispute) { true }

          it "renders content" do
            expect(page_text_within("#table-property_entry")).to include("Disputed asset")
          end
        end
      end

      context "when home is owned outright" do
        let(:session_data) do
          build(:minimal_complete_session,
                property_owned: "outright",
                house_value: 200_000,
                mortgage: nil,
                percentage_owned: 50,
                house_in_dispute: false)
        end

        it "renders content" do
          expect_in_text(text, [
            "Does your client own the home the client lives in?Yes, owned outright",
            "Home client lives in detailsChange",
            "Estimated value£200,000.00",
            "Percentage share owned50%",
          ])
        end
      end

      context "when does not own the home" do
        let(:session_data) do
          build(:minimal_complete_session,
                property_owned: "none",
                house_value: 0,
                mortgage: nil,
                percentage_owned: 0,
                house_in_dispute: false)
        end

        it "renders content" do
          expect(text).to include("Does your client own the home the client lives in?No")
        end
      end
    end

    context "when additional property" do
      let(:additional_house_in_dispute) { false }
      let(:session_data) do
        build(:minimal_complete_session,
              additional_property_owned:,
              additional_properties: [{
                "house_value" => 100_000,
                "percentage_owned" => 100,
                "mortgage" => additional_mortgage,
                "house_in_dispute" => additional_house_in_dispute,
              }])
      end

      context "when owned outright" do
        let(:additional_property_owned) { "outright" }
        let(:additional_mortgage) { nil }

        it "renders content" do
          expect(page_text_within("#table-additional_property")).to include(
            "Does your client own any other property, a holiday home or land?Yes, owned outright",
          )

          expect_in_text(page_text_within("#table-additional_property_details"), [
            "Client other property 1 details",
            "How much is the property, holiday home or land worth?£100,000.00",
            "What percentage does your client own?100%",
          ])
        end

        context "when smod" do
          let(:additional_house_in_dispute) { true }

          it "renders content" do
            expect(page_text).to include("Disputed asset")
          end
        end
      end

      context "when partially owned" do
        let(:additional_property_owned) { "with_mortgage" }
        let(:additional_mortgage) { 2_000 }

        it "renders content" do
          expect(page_text_within("#table-additional_property")).to include(
            "Does your client own any other property, a holiday home or land?Yes, with a mortgage or loan",
          )

          expect_in_text(page_text_within("#table-additional_property_details"), [
            "Client other property 1 details",
            "How much is the property, holiday home or land worth?£100,000.00",
            "Value of outstanding mortgage£2,000.00",
            "What percentage does your client own?100%",
          ])
        end
      end
    end

    context "when multiple additional properties with mortgages" do
      let(:session_data) do
        build(:minimal_complete_session,
              additional_property_owned: "with_mortgage",
              additional_properties: [
                {
                  "house_value" => 100_000,
                  "percentage_owned" => 100,
                  "mortgage" => 2_000,
                  "house_in_dispute" => true,
                },
                {
                  "house_value" => 99_999,
                  "percentage_owned" => 99,
                  "inline_owned_with_mortgage" => true,
                  "mortgage" => 999,
                  "house_in_dispute" => true,
                },
              ])
      end

      let(:text) { page_text_within("#field-list-client_additional_property") }

      it "renders content" do
        expect(page_text_within("#table-additional_property")).to include(
          "Does your client own any other property, a holiday home or land?Yes, with a mortgage or loan",
        )

        expect_in_text(page_text_within("#table-additional_property_details"), [
          "Client other property 1 details",
          "How much is the property, holiday home or land worth?£100,000.00",
          "Value of outstanding mortgage£2,000.00",
          "What percentage does your client own?100%",
        ])

        expect_in_text(page_text_within("#table-additional_property_details-1"), [
          "Client other property 2 details",
          "How much is the property, holiday home or land worth?£99,999.00",
          "Is there an outstanding mortgage on the property, holiday home or land?Yes",
          "Value of outstanding mortgage£999.00",
          "What percentage does your client own?99%",
        ])
      end
    end

    context "when multiple additional properties without mortgages" do
      let(:session_data) do
        build(:minimal_complete_session,
              additional_property_owned: "outright",
              additional_properties: [
                {
                  "house_value" => 100_000,
                  "percentage_owned" => 100,
                  "house_in_dispute" => false,
                },
                {
                  "house_value" => 99_999,
                  "percentage_owned" => 99,
                  "inline_owned_with_mortgage" => false,
                  "house_in_dispute" => false,
                },
              ])
      end

      it "renders content" do
        expect(page_text_within("#table-additional_property")).to include(
          "Does your client own any other property, a holiday home or land?Yes, owned outright",
        )

        expect_in_text(page_text_within("#table-additional_property_details"), [
          "Client other property 1 details",
          "How much is the property, holiday home or land worth?£100,000.00",
          "What percentage does your client own?100%",
        ])

        expect_in_text(page_text_within("#table-additional_property_details-1"), [
          "Client other property 2 details",
          "How much is the property, holiday home or land worth?£99,999.00",
          "Is there an outstanding mortgage on the property, holiday home or land?No",
          "What percentage does your client own?99%",
        ])
      end
    end
  end
end
