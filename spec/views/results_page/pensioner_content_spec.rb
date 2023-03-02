require "rails_helper"

RSpec.describe "estimates/show.html.slim" do
  describe "Pensioner content" do
    let(:calculation_result) { CalculationResult.new(api_response).tap { _1.level_of_help = "certificated" } }
    let(:estimate) { EstimateModel.from_session(session_data) }

    let(:session_data) do
      {}.with_indifferent_access
    end

    before do
      assign(:model, calculation_result)
      assign(:estimate, estimate)
      params[:id] = :id
      render template: "estimates/show"
    end

    context "when client has a partner and is over 60" do
      let(:api_response) { FactoryBot.build(:api_result, partner: true, over_60: true) }

      it "shows a separate pensioner disregard table" do
        expect(rendered).to include '<caption class="govuk-table__caption govuk-table__caption--m">Pensioner disregard'
      end
    end

    context "when client has no partner and is over 60" do
      let(:api_response) { FactoryBot.build(:api_result, partner: false, over_60: true) }

      it "shows pensioner disregard in the main capital table" do
        expect(rendered).to include '<th class="govuk-table__header">Pensioner disregard'
      end
    end
  end
end
