require "rails_helper"

RSpec.describe "Welcome", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "displays the dummy home page" do
    visit "/"
    expect(page).to have_content "Your application is ready"
  end

  describe "intro form", :vcr do
    let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
    before do
      travel_to arbitrary_fixed_time
      visit "/estimates/new"
    end

    after do
      travel_back
    end

    it "gives errors if nothing selected" do
      click_on "Save and continue"
      expect(page).to have_css(".govuk-error-summary__list")
    end

    it "shows the Intro screen" do
      expect(page).to have_content "Intro Page Template"
    end

    context "intro and monthly_income screens" do
      before do
        select_intro_boolean(:over_60, true)
        select_intro_boolean(:dependants, false)
        select_intro_boolean(:partner, false)
        select_intro_boolean(:employed, false)
        select_intro_boolean(:passporting, passporting)
      end

      context "passporting" do
        let(:passporting) { true }

        before do
          click_on "Save and continue"
        end

        it "skips income and outgoings" do
          expect(page).to have_content "Property Page Template"
        end

        it "has a back pointer to the intro template" do
          click_on "Back"
          expect(page).to have_content "Intro Page Template"
        end

        it "sets error on property form" do
          click_on "Save and continue"
          expect(page).to have_css(".govuk-error-summary__list")
        end

        it "can fill in the property, vehicle and assets questions with no answer" do
          click_checkbox("property-form-property-owned", "none")
          click_on "Save and continue"

          select_boolean_value("vehicle-form", :vehicle_owned, false)
          click_on "Save and continue"

          click_checkbox("assets-form-assets", "none")
          click_on "Save and continue"

          expect(page).to have_content "Summary Page"
          click_on "Save and continue"

          expect(page).to have_content "Results Page"
        end
      end

      context "not passporting" do
        let(:passporting) { false }

        before do
          click_on "Save and continue"
        end

        it "shows income" do
          expect(page).to have_content "Monthly Income Page Template"
        end

        it "validates presence of a checked field" do
          click_checkbox("monthly-income-form-monthly-incomes", "employment_income")
          click_on "Save and continue"
          within ".govuk-error-summary__list" do
            expect(page).to have_content("is not a number")
          end
        end

        it "validates that at least one field is checked" do
          click_on "Save and continue"
          expect(page).to have_css(".govuk-error-summary__list")
        end

        it "allows no income to be selected" do
          click_checkbox("monthly-income-form-monthly-incomes", "none")
          click_on "Save and continue"
          expect(page).not_to have_css(".govuk-error-summary__list")
        end
      end
    end
  end

  def click_checkbox(form_name, field)
    fieldname = field.to_s.tr("_", "-")
    find("label[for=#{form_name}-#{fieldname}-field]").click
  end

  def select_intro_boolean(field, value)
    select_boolean_value("intro-form", field, value)
  end

  def select_boolean_value(form_name, field, value)
    fieldname = field.to_s.tr("_", "-")
    if value
      find("label[for=#{form_name}-#{fieldname}-true-field]").click
    else
      find("label[for=#{form_name}-#{fieldname}-field]").click
    end
  end
end
