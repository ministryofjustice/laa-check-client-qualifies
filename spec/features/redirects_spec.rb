require "rails_helper"

RSpec.describe "Redirects" do
  scenario "I try to visit the old URL for a check" do
    set_session(:foo, "level_of_help" => "controlled")
    visit "/estimates/foo/build_estimates/immigration_or_asylum"
    expect(page).to have_current_path("/is-this-immigration-asylum-matter/foo")
  end

  scenario "I try to visit the old check answers URL for a check" do
    set_session(:foo, "level_of_help" => "controlled")
    visit "/estimates/foo/check_answers/immigration_or_asylum"
    expect(page).to have_current_path("/is-this-immigration-asylum-matter/foo/check")
  end

  scenario "I try to visit the old results URL for a check" do
    set_session(:foo, "level_of_help" => "controlled", "api_response" => build(:api_result))
    visit "/estimates/foo"
    expect(page).to have_current_path("/check-result/foo")
  end

  scenario "I try to visit the CW form URL for a check" do
    set_session(:foo, "level_of_help" => "controlled", "api_response" => build(:api_result))
    visit "/estimates/foo/controlled_work_document_selections/new"
    expect(page).to have_current_path("/which-controlled-work-form/foo")
  end
end
