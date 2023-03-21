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

    context "when there is partner employment information" do
      let(:session_data) do
        build(:minimal_complete_session,
              :with_partner,
              employment_status: "unemployed",
              partner_employment_status:,
              partner_frequency: "monthly",
              partner_gross_income: 1_500,
              partner_income_tax: 200,
              partner_national_insurance: 100)
      end

      context "when the partner is employed and in work" do
        let(:partner_employment_status) { "in_work" }

        it "renders content" do
          expect(text).to include("Partner employment statusEmployed and in work")
          expect(text).to include("FrequencyEvery month")
          expect(text).to include("Gross pay£1,500.00")
          expect(text).to include("Income tax£200.00")
          expect(text).to include("National Insurance£100.00")
        end
      end

      context "when the partner is employed but on statuatory sick/maternity pay" do
        let(:partner_employment_status) { "receiving_statutory_pay" }

        it "renders content" do
          expect(text).to include("Partner employment statusEmployed and on Statutory Sick Pay or Statutory Maternity Pay")
        end
      end

      context "when the partner is unemployed" do
        let(:session_data) do
          build(:minimal_complete_session,
                :with_partner,
                :with_employment,
                partner_employment_status: "unemployed")
        end

        it "renders content" do
          expect(text).to include("Partner employment statusUnemployed")
        end
      end
    end
  end
end
