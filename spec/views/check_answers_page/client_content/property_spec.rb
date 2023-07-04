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
          expect(text).to include("Owns the home they live inYes")
          expect(text).to include("Estimated value£200,000.00")
          expect(text).to include("Outstanding mortgage£5,000.00")
          expect(text).to include("Percentage share owned50%")
        end

        context "when is smod" do
          let(:house_in_dispute) { true }

          it "renders content" do
            expect(page_text_within("#field-list-property")).to include("Disputed asset")
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
          expect(text).to include("Owns the home they live inYes")
          expect(text).to include("Estimated value£200,000.00")
          expect(text).to include("Percentage share owned50%")
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
          expect(text).to include("Owns the home they live inNo")
          expect(page_text_within("#field-list-property")).not_to include("Disputed asset")
        end
      end
    end

    context "when additional property" do
      let(:additional_house_in_dispute) { false }
      let(:session_data) do
        build(:minimal_complete_session,
              additional_property_owned:,
              additional_house_value: 100_000,
              additional_mortgage:,
              additional_percentage_owned: 100,
              additional_house_in_dispute:)
      end

      let(:text) { page_text_within("#field-list-client_additional_property") }

      context "when owned outright" do
        let(:additional_property_owned) { "outright" }
        let(:additional_mortgage) { nil }

        it "renders content" do
          expect(text).to include("Owns other propertyYes, owned outright")
          expect(text).to include("Estimated value£100,000.00")
          expect(text).to include("Percentage share owned100%")
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
          expect(text).to include("Owns other propertyYes, with a mortgage or loan")
          expect(text).to include("Estimated value£100,000.00")
          expect(text).to include("Outstanding mortgage£2,000.00")
          expect(text).to include("Percentage share owned100%")
        end
      end
    end
  end
end
