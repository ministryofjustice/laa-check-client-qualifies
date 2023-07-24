require "rails_helper"

RSpec.describe "estimates/show.html.slim" do
  describe "Types of evidence content" do
    let(:calculation_result) { CalculationResult.new("api_response" => api_result) }
    let(:api_result) { FactoryBot.build(:api_result) }
    let(:check) { Check.new(session_data) }

    let(:session_data) do
      {
        api_response:,
        level_of_help:,
      }.with_indifferent_access
    end

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      params[:id] = :id
      render template: "estimates/show"
    end

    context "when eligible for certificated work with self employed flag enabled", :self_employed_flag do
      let(:level_of_help) { "certificated" }
      let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }

      it "shows relevant text" do
        expect(page_text).to include "3 months of Prisoner Income and Expenditure Statements (PIES)"
        expect(page_text).to include "If the client or any partner are self-employed:"
        expect(page_text).to include "Most recent set of trading accounts or self-assessment tax return"
      end
    end

    context "when eligible for certificated work without self employed flag enabled" do
      let(:level_of_help) { "certificated" }
      let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }

      it "shows relevant text" do
        expect(page_text).to include "3 months of Prisoner Income and Expenditure Statements (PIES)"
        expect(page_text).not_to include "If the client or any partner are self-employed:"
        expect(page_text).not_to include "Most recent set of trading accounts or self-assessment tax return"
      end
    end
  end
end
