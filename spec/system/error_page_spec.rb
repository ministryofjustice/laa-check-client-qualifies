require "rails_helper"

RSpec.describe "Error Page" do
  it "has no AXE-detectable accessibility issues" do
    visit "/500"
    expect(page).to be_axe_clean
  end
end
