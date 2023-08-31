require "rails_helper"

RSpec.describe "Updates page" do
  scenario "I can view the updates page" do
    visit root_path
    click_on "Updates"
    expect(page).to have_current_path "/updates"
    expect(page).to have_content "Changes for clients aged under 18"
  end

  scenario "I can view details of an active issue" do
    travel_to Time.zone.local(2023, 6, 1, 18, 0) # Note that this is 7pm BST
    issue = create :issue
    create :issue_update, issue:, utc_timestamp: 1.hour.ago, content: "We have identified the source of the problem"
    create :issue_update, issue:, utc_timestamp: 25.hours.ago, content: "We are aware of a problem"
    visit updates_path
    expect(page).to have_content "1 June 2023\n#{issue.title}\nactive\nStatus: Unresolved"
    expect(page).to have_content "18:00\nWe have identified the source of the problem"
    expect(page).to have_content "31 May 2023 18:00\nWe are aware of a problem"
  end

  scenario "I can view details of a resolved issue" do
    travel_to Time.zone.local(2023, 6, 1, 18, 0)
    issue = create :issue, status: Issue.statuses[:resolved]
    create :issue_update, issue:, utc_timestamp: 1.hour.ago, content: "We fixed the problem"
    create :issue_update, issue:, utc_timestamp: 25.hours.ago, content: "We are aware of a problem"
    visit updates_path
    expect(page).to have_content "1 June 2023\n#{issue.title}\nresolved\nStatus: Resolved 1 June 2023 18:00"
    expect(page).to have_content "18:00\nWe fixed the problem"
    expect(page).to have_content "31 May 2023 18:00\nWe are aware of a problem"
  end
end
