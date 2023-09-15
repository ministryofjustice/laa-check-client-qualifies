require "rails_helper"

RSpec.describe "checks/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    params[:assessment_code] = :code
    allow(view).to receive(:form_with)
    render template: "checks/check_answers"
  end

  describe "client sections" do
    let(:text) { page_text }

    context "when the client is unemployed" do
      let(:session_data) { build(:minimal_complete_session) }

      it "renders content" do
        expect(text).to include("What is your client's employment status?Unemployed")
      end
    end

    context "when the client has incomes" do
      let(:session_data) do
        build(:minimal_complete_session,
              employment_status: "in_work",
              incomes: [
                {
                  "income_type" => "employment",
                  "income_frequency" => "monthly",
                  "gross_income" => 100,
                  "income_tax" => 20,
                  "national_insurance" => 3,
                },
                {
                  "income_type" => "self_employment",
                  "income_frequency" => "three_months",
                  "gross_income" => 500,
                  "income_tax" => 100,
                  "national_insurance" => 0,
                },
              ])
      end

      it "shows employment status in the employment section" do
        expect(page_text_within("#table-employment_status")).to include "What is your client's employment status?Employed or self-employed"
      end

      it "Shows details of incomes" do
        expect_in_text(page_text_within("#table-income"), [
          "What type of employment income is this?A salary or wage",
          "When does your client normally get this income?Monthly",
          "Income before any deductions£100.00",
          "Income tax£20.00",
          "National Insurance£3.00",
        ])
        expect_in_text(page_text_within("#table-income-1"), [
          "What type of employment income is this?Self-employment income",
          "When does your client normally get this income?Total in last 3 months",
          "Income before any deductions£500.00",
          "Income tax£100.00",
          "National Insurance£0.00",
        ])
      end
    end
  end
end
