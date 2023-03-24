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
    context "when employment" do
      let(:session_data) do
        build(:minimal_session,
              employment_status:,
              frequency: "monthly",
              gross_income: 1_500,
              income_tax: 200,
              national_insurance: 100)
      end

      context "when the client is employed and in work" do
        let(:employment_status) { "in_work" }

        it "renders content" do
          expect(page_text).to include("Employment statusEmployed and in work")
          expect(page_text).to include("FrequencyEvery month")
          expect(page_text).to include("Gross pay£1,500.00")
          expect(page_text).to include("Income tax£200.00")
          expect(page_text).to include("National Insurance£100.00")
        end
      end

      context "when the client is employed but on statuatory sick/maternity pay" do
        let(:employment_status) { "receiving_statutory_pay" }

        it "renders content" do
          expect(page_text).to include("Employment statusEmployed and on Statutory Sick Pay or Statutory Maternity Pay")
        end
      end

      context "when the client is unemployed" do
        let(:session_data) { build(:minimal_session) }

        it "renders content" do
          expect(page_text).to include("Employment statusUnemployed")
        end
      end
    end
  end
end
