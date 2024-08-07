require "rails_helper"

RSpec.describe "Under 18 flow", type: :feature do
  let(:clr_text) { "Is the work controlled legal representation" }

  before do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
  end

  it "shows additional questions for u18 controlled checks" do
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "No")
    fill_in_aggregated_means_screen(choice: "No")
    fill_in_regular_income_screen(choice: "No")
    fill_in_under_eighteen_assets_screen(choice: "No")
    confirm_screen(:check_answers)
    expect(page).to have_content clr_text
  end

  it "exits early for certificated work" do
    fill_in_level_of_help_screen(choice: "Civil certificated")
    confirm_screen(:check_answers)
    expect(page).not_to have_content clr_text
  end

  it "exits early if means are aggregated certificated work" do
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "No")
    fill_in_aggregated_means_screen(choice: "Yes")
    fill_in_how_to_aggregate_screen
    confirm_screen("immigration_or_asylum")
  end

  it "exits to Check your answers if it is Controlled Legal Representation work" do
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "Yes")
    confirm_screen(:check_answers)
  end

  it "exits early if regular income" do
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "No")
    fill_in_aggregated_means_screen(choice: "No")
    fill_in_regular_income_screen(choice: "Yes")
    confirm_screen("immigration_or_asylum")
  end

  it "does not skip to check answers if assets" do
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "No")
    fill_in_aggregated_means_screen(choice: "No")
    fill_in_regular_income_screen(choice: "No")
    fill_in_under_eighteen_assets_screen(choice: "Yes")
    confirm_screen("immigration_or_asylum")
  end
end
