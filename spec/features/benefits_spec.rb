require "rails_helper"

RSpec.describe "Benefits" do
  let(:estimate_id) { SecureRandom.uuid }

  before do
    visit estimate_build_estimate_path(estimate_id, :benefits)
  end

  it "checks I have made a choice" do
    click_on("Save and continue")
    expect(page).to have_content("Select yes if you wish to add a client benefit")
  end

  it "allows me to skip past the screen" do
    select_boolean_value("benefits-form", :add_benefit, false)
    click_on("Save and continue")
    expect(page).to have_content("What other income does your client receive?")
  end

  it "allows me to enter a benefit" do
    select_boolean_value("benefits-form", :add_benefit, true)
    click_on "Save and continue"
    fill_in "Benefit type", with: "Child benefit"
    fill_in "Enter amount", with: "150"
    choose "Every week"
    click_on "Save and continue"
    expect(page).to have_content "Child benefit"
    expect(page).to have_content "£150"
  end

  it "validates my input" do
    select_boolean_value("benefits-form", :add_benefit, true)
    click_on "Save and continue"
    fill_in "Benefit type", with: ""
    fill_in "Enter amount", with: "150"
    choose "Every week"
    click_on "Save and continue"
    expect(page).to have_content "Please give the name of the benefit"
  end

  it "allows me to edit a benefit" do
    select_boolean_value("benefits-form", :add_benefit, true)
    click_on "Save and continue"
    fill_in "Benefit type", with: "Child benefit"
    fill_in "Enter amount", with: "150"
    choose "Every week"
    click_on "Save and continue"
    click_on "Change"
    fill_in "Benefit type", with: "Children benefit"
    click_on "Save and continue"
    expect(page).to have_content "Children benefit"
  end

  it "validates my edits" do
    select_boolean_value("benefits-form", :add_benefit, true)
    click_on "Save and continue"
    fill_in "Benefit type", with: "Child benefit"
    fill_in "Enter amount", with: "150"
    choose "Every week"
    click_on "Save and continue"
    click_on "Change"
    fill_in "Benefit type", with: ""
    click_on "Save and continue"
    expect(page).to have_content "Please give the name of the benefit"
  end

  it "allows me to remove a benefit" do
    select_boolean_value("benefits-form", :add_benefit, true)
    click_on "Save and continue"
    fill_in "Benefit type", with: "Child benefit"
    fill_in "Enter amount", with: "150"
    choose "Every week"
    click_on "Save and continue"
    click_on "Remove"
    expect(page).not_to have_content "Child benefit"
    expect(page).to have_current_path(new_estimate_benefit_path(estimate_id))
  end

  it "allows me to remove one benefit of multiple" do
    select_boolean_value("benefits-form", :add_benefit, true)
    click_on "Save and continue"
    fill_in "Benefit type", with: "Child benefit"
    fill_in "Enter amount", with: "150"
    choose "Every week"
    click_on "Save and continue"
    select_boolean_value("benefits-form", :add_benefit, true)
    click_on "Save and continue"
    fill_in "Benefit type", with: "Tax credits"
    fill_in "Enter amount", with: "100"
    choose "Every week"
    click_on "Save and continue"
    find(".button-as-link", match: :first).click
    expect(page).not_to have_content "Child benefit"
    expect(page).to have_current_path(estimate_build_estimate_path(estimate_id, :benefits))
  end
end
