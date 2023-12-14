require "rails_helper"

RSpec.describe "Under 18 flow", :under_eighteen_flag, type: :feature do
  it "shows additional questions form u18 controlled checks if flag is enabled" do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "No")
    fill_in_aggregated_means_screen(choice: "No")
    fill_in_regular_income_screen(choice: "No")
    fill_in_under_eighteen_assets_screen(choice: "No")
    confirm_screen("check_answers")
  end

  it "exits early for certificated work" do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil certificated")
    confirm_screen("check_answers")
  end

  it "exits early if means are aggregated certificated work" do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "No")
    fill_in_aggregated_means_screen(choice: "Yes")
    fill_in_how_to_aggregate_screen
    confirm_screen("immigration_or_asylum")
  end

  it "exits to Check your answers if it is Controlled Legal Representation work" do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "Yes")
    confirm_screen("check_answers")
  end

  it "exits early if regular income" do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "No")
    fill_in_aggregated_means_screen(choice: "No")
    fill_in_regular_income_screen(choice: "Yes")
    confirm_screen("immigration_or_asylum")
  end

  it "does not skip to check answers if assets" do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "No")
    fill_in_aggregated_means_screen(choice: "No")
    fill_in_regular_income_screen(choice: "No")
    fill_in_under_eighteen_assets_screen(choice: "Yes")
    confirm_screen("immigration_or_asylum")
  end
end
