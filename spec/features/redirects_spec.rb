require "rails_helper"

RSpec.describe "Redirects" do
  scenario "I try to visit the old URL for a check" do
    set_session(:foo, "level_of_help" => "controlled")
    visit "/estimates/foo/build_estimates/matter_type"
    expect(page).to have_current_path("/which-matter-type/foo")
  end

  scenario "I try to visit the old check answers URL for a check" do
    set_session(:foo, "level_of_help" => "controlled")
    visit "/estimates/foo/check_answers/matter_type"
    expect(page).to have_current_path("/which-matter-type/foo/check")
  end
end
