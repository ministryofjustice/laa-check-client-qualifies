require "rails_helper"

RSpec.describe "Under 18 flow", :under_eighteen_flag, type: :feature do
  it "shows additional questions form u18 controlled checks if flag is enabled" do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_aggregated_means_screen(choice: "No")
    fill_in_regular_income_screen(choice: "No")
    # TODO: Check that depending on the answer given, this redirects to the next appropriate screen
  end

  it "exits early for certificated work" do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil certificated")
    confirm_screen("domestic_abuse_applicant")
  end

  it "exits early if means are aggregated certificated work" do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_aggregated_means_screen(choice: "Yes")
    confirm_screen("immigration_or_asylum")
  end
end
