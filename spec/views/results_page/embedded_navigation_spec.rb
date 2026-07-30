require "rails_helper"

RSpec.describe "results/show.html.slim" do
  describe "Embedded navigation" do
    let(:session_data) do
      {
        api_response: FactoryBot.build(:api_result, eligible: "eligible"),
        level_of_help: "certificated",
      }.with_indifferent_access
    end

    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:check) { Check.new(session_data) }

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      params[:assessment_code] = :code
    end

    context "when rendered in embedded mode" do
      before do
        assign(:embedded_case_path, "/cases/123")
        render template: "results/show"
      end

      it "shows a back to case button" do
        fragment = Nokogiri::HTML.fragment(rendered)
        link = fragment.at_css("a#back_to_case")

        expect(link).not_to be_nil
        expect(link["href"]).to eq("/cases/123")
        expect(link.text).to include("Back to case")
      end
    end

    context "when not rendered in embedded mode" do
      before do
        render template: "results/show"
      end

      it "does not show a back to case button" do
        fragment = Nokogiri::HTML.fragment(rendered)
        expect(fragment.at_css("a#back_to_case")).to be_nil
      end
    end
  end
end
