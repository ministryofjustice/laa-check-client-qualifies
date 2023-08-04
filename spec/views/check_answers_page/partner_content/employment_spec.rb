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
          expect_in_text(text, [
            "When does the partner normally get paid?Monthly",
            "Income before any deductions£1,500.00",
            "Income tax£200.00",
            "National Insurance£100.00",
          ])
        end

        it "shows employment status in partner details section" do
          expect(page_text_within("#table-partner_details")).to include "What is the partner's employment status?Employed and in work"
        end

        context "when self-employed feature flag is enabled", :self_employed_flag do
          it "does not show employment status in partner details section" do
            expect(page_text_within("#table-partner_details")).not_to include "What is the partner's employment status?"
          end

          it "shows employment status in the employment section" do
            expect(page_text_within("#table-partner_employment_status")).to include "What is the partner's employment status?Employed or self-employed"
          end
        end
      end

      context "when the partner is employed but on statuatory sick/maternity pay" do
        let(:partner_employment_status) { "receiving_statutory_pay" }

        it "renders content" do
          expect(text).to include("What is the partner's employment status?Employed and on Statutory Sick Pay or Statutory Maternity Pay")
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
          expect(text).to include("What is the partner's employment status?Unemployed")
        end
      end
    end
  end
end
