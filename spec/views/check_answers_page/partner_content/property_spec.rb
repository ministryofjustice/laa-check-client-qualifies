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
    context "when there is partner property" do
      context "when home is owned with a mortgage or loan" do
        let(:session_data) do
          build(:minimal_session,
                :with_partner,
                partner_property_owned: "with_mortgage",
                partner_house_value: 200_000,
                partner_mortgage: 5_000,
                partner_percentage_owned: 50)
        end

        it "renders content" do
          expect(page_text).to include("Owns the home they live itYes")
          expect(page_text).to include("Estimated value£200,000.00")
          expect(page_text).to include("Outstanding mortgage£5,000.00")
          expect(page_text).to include("Percentage share owned50")
        end
      end

      context "when home is owned outright" do
        let(:session_data) do
          build(:minimal_session,
                :with_partner,
                partner_property_owned: "outright",
                partner_house_value: 200_000,
                partner_mortgage: nil,
                partner_percentage_owned: 50)
        end

        it "renders content" do
          expect(page_text).to include("Owns the home they live itYes")
          expect(page_text).to include("Estimated value£200,000.00")
          expect(page_text).to include("Outstanding mortgageNot applicable")
          expect(page_text).to include("Percentage share owned50")
        end
      end

      context "when partner does not own the home" do
        let(:session_data) do
          build(:minimal_session,
                :with_partner,
                partner_property_owned: "none",
                partner_house_value: 0.0,
                partner_mortgage: nil,
                partner_percentage_owned: 0.0)
        end

        it "renders content" do
          expect(page_text).to include("Owns the home they live itNo")
        end
      end
    end
  end
end
