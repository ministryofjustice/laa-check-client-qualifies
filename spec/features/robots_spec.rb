require "rails_helper"

RSpec.describe "Robots" do
  context "when the flag is turned on", :index_production_flag do
    it "does not have disallow in robots.txt" do
      visit "/robots.txt"
      expect(page).not_to have_content "Disallow: /"
    end
  end

  context "when the flag is NOT enabled" do
    it "does have disallow in robots.txt" do
      visit "/robots.txt"
      expect(page).to have_content "Disallow: /"
    end
  end
end
