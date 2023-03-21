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
    context "when dependants" do
      context "when multiple dependants" do
        let(:session_data) do
          build(:minimal_session,
                child_dependants: true,
                child_dependants_count: 1,
                adult_dependants: true,
                adult_dependants_count: 2)
        end

        it "renders content" do
          expect(page_text).to include("Has child dependantsYes")
          expect(page_text).to include("Number of child dependants1")
          expect(page_text).to include("Has adult dependantsYes")
          expect(page_text).to include("Number of adult dependants2")
        end
      end

      context "when no dependants" do
        let(:session_data) do
          build(:minimal_session,
                child_dependants: nil,
                adult_dependants: nil)
        end

        it "renders content" do
          expect(page_text).to include("Has child dependantsNo")
          expect(page_text).to include("Has adult dependantsNo")
        end
      end
    end
  end
end
