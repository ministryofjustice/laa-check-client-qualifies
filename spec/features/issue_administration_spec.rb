require "rails_helper"

RSpec.describe "Issue administration" do
  before do
    travel_to Time.zone.local(2023, 2, 1, 9, 0)
    authenticate_as_admin
  end

  scenario "I publish a new issue" do
    within(".navbar") { click_on "Publish new issue" }
    fill_in "Banner text", with: "A problem has been identified with childcare costs."
    fill_in "Problem title", with: "Problem with childcare costs"
    fill_in "Description", with: "We are working to resolve the problem"
    click_on "Publish"
    expect(page).to have_content "Issue published"
    visit root_path
    expect(page).to have_content "A problem has been identified with childcare costs. Learn more."
    visit updates_path
    expect(page).to have_content "Problem with childcare costs\nactive"
  end

  scenario "I leave fields blank" do
    within(".navbar") { click_on "Publish new issue" }
    click_on "Publish"
    expect(page).to have_content "Title can't be blank"
  end

  context "when an issue is live" do
    before do
      within(".navbar") { click_on "Publish new issue" }
      fill_in "Banner text", with: "A problem has been identified with childcare costs."
      fill_in "Problem title", with: "Problem with childcare costs"
      fill_in "Description", with: "We are working to resolve the problem"
      click_on "Publish"
    end

    scenario "I update an issue" do
      click_on "Publish update"
      fill_in "Update description", with: "We have identified the source of the problem"
      click_on "Update"
      visit updates_path
      expect(page).to have_content "We have identified the source of the problem"
    end

    scenario "I leave update fields blank" do
      click_on "Publish update"
      click_on "Update"
      expect(page).to have_content "Content can't be blank"
    end

    scenario "I resolve an issue" do
      click_on "Resolve"
      fill_in "Resolution text", with: "We have fixed the problem"
      click_on "Resolve problem"
      visit root_path
      expect(page).to have_content "We have resolved the problem with childcare costs. Learn more."
      visit updates_path
      expect(page).to have_content "Problem with childcare costs\nresolved"
      expect(page).to have_content "We have fixed the problem"
    end

    scenario "I leave resolution fields blank" do
      click_on "Resolve"
      click_on "Resolve problem"
      expect(page).to have_content "Content can't be blank"
    end
  end
end
