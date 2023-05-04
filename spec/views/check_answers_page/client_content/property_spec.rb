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
                house_in_dispute:,
                joint_ownership: nil,
                joint_percentage_owned: nil)
        end

        let(:house_in_dispute) { false }

        it "renders content" do
          expect(text).to include("Owns the home they live inYes")
          expect(text).to include("Estimated value£200,000.00")
          expect(text).to include("Outstanding mortgage£5,000.00")
          expect(text).to include("Percentage share owned50")
        end

        context "when is smod" do
          let(:house_in_dispute) { true }

          it "renders content" do
            expect(page_text_within("#field-list-property")).to include("Disputed asset")
          end
        end
      end

      context "when home is owned outright and there is no partner" do
        let(:session_data) do
          build(:minimal_complete_session,
                property_owned: "outright",
                house_value: 200_000,
                mortgage: nil,
                percentage_owned: 50,
                house_in_dispute: false,
                joint_ownership: nil,
                partner: false,
                joint_percentage_owned: nil)
        end

        it "renders content" do
          expect(text).to include("Owns the home they live inYes")
          expect(text).to include("Estimated value£200,000.00")
          expect(text).to include("Outstanding mortgageNot applicable")
          expect(text).to include("Percentage share owned50")
          expect(text).not_to include("Joint owned with partner")
          expect(text).not_to include("Percentage share owned by partner")
        end
      end

      context "when home is owned outright and there is a partner" do
        let(:session_data) do
          build(:minimal_complete_session,
                property_owned: "outright",
                house_value: 200_000,
                mortgage: nil,
                percentage_owned: 50,
                house_in_dispute: false,
                joint_ownership: false,
                partner: true,
                joint_percentage_owned: nil)
        end

        it "renders content" do
          expect(text).to include("Owns the home they live inYes")
          expect(text).to include("Estimated value£200,000.00")
          expect(text).to include("Outstanding mortgageNot applicable")
          expect(text).to include("Percentage share owned50")
          expect(text).to include("Joint owned with partnerNo")
          expect(text).not_to include("Percentage share owned by partner")
        end
      end

      context "when home is owned outright with partner" do
        let(:session_data) do
          build(:minimal_complete_session,
                partner: true,
                property_owned: "outright",
                house_value: 200_000,
                mortgage: nil,
                percentage_owned: 50,
                house_in_dispute: false,
                joint_ownership: true,
                joint_percentage_owned: 25)
        end

        it "renders content" do
          expect(text).to include("Owns the home they live inYes")
          expect(text).to include("Estimated value£200,000.00")
          expect(text).to include("Outstanding mortgageNot applicable")
          expect(text).to include("Percentage share owned50")
          expect(text).to include("Joint owned with partnerYes")
          expect(text).to include("Percentage share owned by partner25")
        end
      end

      context "when does not own the home" do
        let(:session_data) do
          build(:minimal_complete_session,
                property_owned: "none",
                house_value: 0,
                mortgage: nil,
                percentage_owned: 0,
                house_in_dispute: false,
                joint_ownership: nil,
                joint_percentage_owned: nil)
        end

        it "renders content" do
          expect(text).to include("Owns the home they live inNo")
          expect(page_text_within("#field-list-property")).not_to include("Disputed asset")
        end
      end
    end
  end
end
