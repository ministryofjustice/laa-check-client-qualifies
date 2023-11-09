require "rails_helper"

RSpec.describe "results/show.html.slim", :end_of_journey_flag do
  describe "feedback widget" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:check) { Check.new(session_data) }
    let(:session_data) do
      {
        api_response: FactoryBot.build(:api_result, eligible: "eligible"),
        level_of_help: "controlled",
      }.with_indifferent_access
    end

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      params[:assessment_code] = :code
      render template: "results/show"
    end

    it "shows correct feedback widget on the results page" do
      expect(page_text).to include "Give feedback on this page"
    end
  end
end
