require "rails_helper"

RSpec.describe "IntroPage", :vcr, type: :system do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 6, 9, 0, 0) }
  before do
    travel_to arbitrary_fixed_time
  end

  after do
    travel_back
  end

  it "is axe clean" do
    visit "/estimates/new"
    expect(page).to be_axe_clean
  end
end
