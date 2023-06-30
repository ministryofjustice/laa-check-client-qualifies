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

    context "when employment" do
      let(:session_data) do
        build(:minimal_complete_session,
              employment_status:,
              frequency: "monthly",
              gross_income: 1_500,
              income_tax: 200,
              national_insurance: 100)
      end

      context "when the client is employed and in work" do
        let(:employment_status) { "in_work" }

        it "renders content" do
          expect(text).to include("Employment statusEmployed and in work")
          expect(text).to include("FrequencyEvery month")
          expect(text).to include("Gross pay£1,500.00")
          expect(text).to include("Income tax£200.00")
          expect(text).to include("National Insurance£100.00")
        end
      end

      context "when the client is employed but on statuatory sick/maternity pay" do
        let(:employment_status) { "receiving_statutory_pay" }

        it "renders content" do
          expect(text).to include("Employment statusEmployed and on Statutory Sick Pay or Statutory Maternity Pay")
        end
      end

      context "when the client is unemployed" do
        let(:session_data) { build(:minimal_complete_session) }

        it "renders content" do
          expect(text).to include("Employment statusUnemployed")
        end
      end
    end

    context "when self-employed feature flag is enabled", :self_employed_flag do
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

      it "does not show employment status in client details section" do
        expect(page_text_within("#field-list-client_details")).not_to include "Employment"
      end

      it "shows employment status in the employment section" do
        expect(page_text_within("#field-list-client_employment")).to include "Employment statusEmployed or self-employed"
      end

      it "Shows details of incomes" do
        texts = [
          "Income typeSalary or wage",
          "FrequencyEvery month",
          "Gross income£100.00",
          "Income tax£20.00",
          "National Insurance£3.00",
          "Additional employment income 1",
          "Income typeSelf-employment income",
          "FrequencyTotal in last 3 months",
          "Gross income£500.00",
          "Income tax£100.00",
          "National Insurance£0.00",
        ]

        # This will fail expressively if any individual line is incorrect
        texts.each do |text|
          expect(page_text_within("#field-list-client_employment_income")).to include text
        end

        # This will fail if the ordering is incorrect
        expect(page_text_within("#field-list-client_employment_income")).to eq texts.join
      end

      context "when data is incomplete" do
        let(:session_data) do
          build(:minimal_complete_session,
                employment_status: "in_work")
        end

        it "does not crash" do
          expect(Nokogiri::HTML.fragment(rendered).at_css("#field-list-client_employment_income")).to eq nil
        end
      end
    end
  end
end
