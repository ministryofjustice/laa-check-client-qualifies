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

    context "when not rendered in embedded mode" do
      before do
        assign(:model, calculation_result)
        assign(:check, check)
        params[:assessment_code] = :code
        render template: "results/show"
      end

      it "does not show a save and continue button" do
        fragment = Nokogiri::HTML.fragment(rendered)
        expect(fragment.at_css("#save_and_continue")).to be_nil
      end
    end
  end

  describe "Embedded navigation", :embedded_only, ccq_mode: :embedded do
    let(:session_data) do
      {
        api_response: FactoryBot.build(:api_result, eligible: "eligible"),
        level_of_help: "certificated",
      }.with_indifferent_access
    end

    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:check) { Check.new(session_data) }
    let(:resource_id) { "123" }

    context "when rendered in embedded mode" do
      before do
        assign(:model, calculation_result)
        assign(:check, check)
        params[:assessment_code] = :code
        params[:resource_id] = resource_id
        assign(:embedded_case_path, "/cases/#{resource_id}/task-list")
        render template: "results/show"
      end

      it "shows a save and continue button that posts to the complete endpoint" do
        fragment = Nokogiri::HTML.fragment(rendered)
        button = fragment.at_css("#save_and_continue")

        expect(button).not_to be_nil
        expect(button.text).to include("Save and continue")
        expect(button.ancestors("form").first["action"]).to eq(embedded_complete_path(resource_id:))
      end
    end
  end
end
