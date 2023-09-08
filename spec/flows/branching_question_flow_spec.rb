require "rails_helper"

RSpec.describe "Branching question flow", type: :feature do
  it "sends me to a referral page if I answer no" do
    start_assessment
    fill_in_provider_users_screen(choice: "No")
    expect(page).to have_current_path(/cannot-use-service\z/)
  end
end
