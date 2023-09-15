require "rails_helper"

RSpec.describe "results/show.html.slim" do
  describe "Pensioner content" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:check) { Check.new(session_data) }

    let(:session_data) do
      {
        api_response:,
      }.with_indifferent_access
    end

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      params[:assessment_code] = :code
      render template: "results/show"
    end

    context "when client has a partner and has had pensioner disregard applied" do
      let(:api_response) do
        FactoryBot.build(
          :api_result,
          partner: true,
          result_summary: build(
            :result_summary,
            capital: build(:capital_summary,
                           pensioner_disregard_applied: 123,
                           total_capital_with_smod: 456),
            partner_capital: build(:capital_summary,
                                   pensioner_disregard_applied: 234,
                                   total_capital_with_smod: 567),
          ),
        )
      end

      it "shows a separate pensioner disregard table" do
        expect(rendered).to include '<caption class="govuk-table__caption govuk-table__caption--m">60 or over disregard (also known as pensioner disregard)'
      end

      it "sums up client and partner values for the separate pensioner disregard table" do
        # 123 + 234 = 357. 456 + 567 = 1023.
        expect(page_text).to include("Total client and partner disposable capital£1,023.0060 or over disregard (also known as pensioner disregard)-£357.00")
      end
    end

    context "when client has a partner and only the partner has had pensioner disregard applied" do
      let(:api_response) do
        FactoryBot.build(
          :api_result,
          partner: true,
          result_summary: build(
            :result_summary,
            capital: build(:capital_summary,
                           pensioner_disregard_applied: 0,
                           total_capital_with_smod: 456),
            partner_capital: build(:capital_summary,
                                   pensioner_disregard_applied: 234,
                                   total_capital_with_smod: 567),
          ),
        )
      end

      it "shows the separate pensioner disregard table" do
        expect(rendered).to include '<caption class="govuk-table__caption govuk-table__caption--m">60 or over disregard (also known as pensioner disregard)'
      end
    end

    context "when client has no partner and has had pensioner disregard applied" do
      let(:api_response) do
        FactoryBot.build(
          :api_result,
          result_summary: build(
            :result_summary,
            capital: build(:capital_summary,
                           pensioner_disregard_applied: 123),
          ),
        )
      end

      it "shows pensioner disregard in the main capital table" do
        expect(rendered).to include '<th class="govuk-table__header" scope="row">60 or over disregard (also known as pensioner disregard)'
      end

      it "shows client pensioner disregard" do
        expect(page_text).to include "60 or over disregard (also known as pensioner disregard)Applied to total capital up to a maximum of £100,000-£123.00"
      end
    end

    context "when client has a partner and has no pensioner disregard applied" do
      let(:api_response) do
        FactoryBot.build(
          :api_result,
          partner: true,
          result_summary: build(
            :result_summary,
            capital: build(:capital_summary,
                           pensioner_disregard_applied: 0,
                           total_capital_with_smod: 456),
            partner_capital: build(:capital_summary,
                                   pensioner_disregard_applied: 0,
                                   total_capital_with_smod: 567),
          ),
        )
      end

      it "shows no separate pensioner disregard table" do
        expect(rendered).not_to include '<caption class="govuk-table__caption govuk-table__caption--m">60 or over disregard (also known as pensioner disregard)'
      end

      it "shows disposable capital sums separately" do
        expect(page_text).to include("Disposable capital£456.00")
        expect(page_text).to include("Disposable capital£567.00")
      end
    end
  end
end
