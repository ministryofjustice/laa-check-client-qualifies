require "rails_helper"

RSpec.describe "Asylum and immigration flow", type: :feature do
  it "adds an asylum support question screen for immigration & asylum proceeding type" do
    start_assessment
    fill_in_forms_until(:immigration_or_asylum_type_upper_tribunal)
    fill_in_immigration_or_asylum_type_upper_tribunal_screen(choice: "Yes, immigration (Upper Tribunal)")
    fill_in_asylum_support_screen
    confirm_screen("applicant")
  end

  it "adds an asylum support question screen for asylum matter type" do
    start_assessment
    fill_in_forms_until(:immigration_or_asylum_type_upper_tribunal)
    fill_in_immigration_or_asylum_type_upper_tribunal_screen(choice: "Yes, asylum (Upper Tribunal)")
    fill_in_asylum_support_screen
    confirm_screen("applicant")
  end

  it "skips to end if asylum support received" do
    start_assessment
    fill_in_forms_until(:immigration_or_asylum_type_upper_tribunal)
    fill_in_immigration_or_asylum_type_upper_tribunal_screen(choice: "Yes, asylum (Upper Tribunal)")
    fill_in_asylum_support_screen(choice: "Yes")
    confirm_screen("check_answers")
  end
end
