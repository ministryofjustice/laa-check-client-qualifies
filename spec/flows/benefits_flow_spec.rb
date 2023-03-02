require "rails_helper"

RSpec.describe "Benefits flow", type: :feature do
  it "allows me to edit a benefit" do
    allow(CfeConnection).to receive(:connection).and_return(
      instance_double(CfeConnection, state_benefit_types: []),
    )

    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen
    fill_in_dependants_screen
    fill_in_housing_benefit_screen
    fill_in_benefits_screen(choice: "Yes")
    fill_in_add_benefit_screen
    click_on "Change"
    fill_in_edit_benefit_screen
    confirm_screen("benefits")
  end

  it "allows me to remove a benefit if I have two" do
    allow(CfeConnection).to receive(:connection).and_return(
      instance_double(CfeConnection, state_benefit_types: []),
    )

    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen
    fill_in_dependants_screen
    fill_in_housing_benefit_screen
    fill_in_benefits_screen(choice: "Yes")
    fill_in_add_benefit_screen
    fill_in_benefits_screen(choice: "Yes")
    fill_in_add_benefit_screen
    find("a", text: "Remove", match: :first).click
    confirm_screen("benefits")
  end

  it "puts me back in the add benefit screen if I remove the only one" do
    allow(CfeConnection).to receive(:connection).and_return(
      instance_double(CfeConnection, state_benefit_types: []),
    )

    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen
    fill_in_dependants_screen
    fill_in_housing_benefit_screen
    fill_in_benefits_screen(choice: "Yes")
    fill_in_add_benefit_screen
    click_on "Remove"
    confirm_screen("benefits/new")
  end
end
