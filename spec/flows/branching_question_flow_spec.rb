RSpec.describe "Branching question flow", type: :feature do
  it "sends me to a referral page if I answer no" do
    start_assessment
    fill_in_provider_users_screen(choice: "No")
    confirm_screen("referrals")
  end
end
