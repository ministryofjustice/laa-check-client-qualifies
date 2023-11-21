require "rails_helper"

RSpec.describe "Under 18 flow", :under_eighteen_flag, type: :feature do
  it "starts with the client age screen" do
    start_assessment
    confirm_screen("client_age")
    fill_in_client_age_screen
    confirm_screen("level_of_help")
    # TODO: Continue flow here
  end
end
