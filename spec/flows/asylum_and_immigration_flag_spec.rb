require "rails_helper"

RSpec.describe "Asylum and immigration flag", :controlled_flag, :asylum_and_immigration_flag, type: :feature do
  it "adds a new matter type screen" do
    start_assessment
    fill_in_provider_screen
    fill_in_level_of_help_screen
    fill_in_matter_type_screen(choice: "Another legal matter")
    confirm_screen("applicant")
  end

  it "adds an asylum support question screen for immigration matter type" do
    start_assessment
    fill_in_provider_screen
    fill_in_level_of_help_screen
    fill_in_matter_type_screen(choice: "Immigration in the First-tier Tribunal")
    fill_in_asylum_support_screen
    confirm_screen("applicant")
  end

  it "adds an asylum support question screen for asylum matter type" do
    start_assessment
    fill_in_provider_screen
    fill_in_level_of_help_screen
    fill_in_matter_type_screen(choice: "Asylum in the First-tier Tribunal")
    fill_in_asylum_support_screen
    confirm_screen("applicant")
  end

  it "skips to end if asylum support received" do
    start_assessment
    fill_in_provider_screen
    fill_in_level_of_help_screen
    fill_in_matter_type_screen(choice: "Asylum in the First-tier Tribunal")
    fill_in_asylum_support_screen(choice: "Yes")
    confirm_screen("check_answers")
  end
end
