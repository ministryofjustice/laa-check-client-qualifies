require "rails_helper"

RSpec.describe "Under 18 flow", :under_eighteen_flag, type: :feature do
  it "shows additional questions form u18 controlled checks if flag is enabled" do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_aggregated_means_screen
    # TODO: Check that depending on the answer given, this redirects to the next appropriate screen
  end
end
