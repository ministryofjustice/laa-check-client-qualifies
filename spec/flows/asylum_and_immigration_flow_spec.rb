require "rails_helper"

RSpec.describe "Asylum and immigration flow", type: :feature do
  it "adds an asylum support question screen for immigration matter type" do
    start_assessment
    fill_in_forms_until(:matter_type)
    fill_in_matter_type_screen(choice: "Immigration")
    fill_in_asylum_support_screen
    confirm_screen("applicant")
  end

  it "adds an asylum support question screen for asylum matter type" do
    start_assessment
    fill_in_forms_until(:matter_type)
    fill_in_matter_type_screen(choice: "Asylum")
    fill_in_asylum_support_screen
    confirm_screen("applicant")
  end

  it "skips to end if asylum support received" do
    start_assessment
    fill_in_forms_until(:matter_type)
    fill_in_matter_type_screen(choice: "Asylum")
    fill_in_asylum_support_screen(choice: "Yes")
    confirm_screen("check_answers")
  end
end
