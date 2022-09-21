require "rails_helper"

RSpec.describe "Welcome", type: :system do
  before do
    driven_by(:rack_test)
    visit "/estimates/#{estimate_id}/build_estimates/new"
  end

  let(:estimate_id) { SecureRandom.uuid }

  it "shows the intro page heading" do
    expect(page).to have_content "Intro Page Template"
  end

  describe "errors" do
    before do
      %i[over_60 dependants partner passporting employed].reject { |f| f == field }.each do |f|
        select_boolean_value("intro-form", f, true)
      end
      click_on "Save and continue"
    end

    describe "over_60" do
      let(:field) { :over_60 }

      it "has an error section" do
        expect(page).to have_css(".govuk-error-summary__list")
      end

      it "displays the correct error message" do
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes if the client is over 60 years old")
        end
      end
    end

    describe "employed" do
      let(:field) { :employed }

      it "displays the correct error message" do
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select employed if the client is currently employed")
        end
      end
    end

    describe "dependants" do
      let(:field) { :dependants }

      it "displays the correct error message" do
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes if the client has any dependants")
        end
      end
    end

    describe "partner" do
      let(:field) { :partner }

      it "displays the correct error message" do
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes if the client has a partner")
        end
      end
    end

    describe "passporting" do
      let(:field) { :passporting }

      it "displays the correct error message" do
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes if the client is currently in receipt of a passporting benefit")
        end
      end
    end
  end

  describe "intro and monthly_income screens" do
    before do
      select_boolean_value("intro-form", :over_60, true)
      select_boolean_value("intro-form", :dependants, true)
      select_boolean_value("intro-form", :partner, true)
      select_boolean_value("intro-form", :employed, true)
      select_boolean_value("intro-form", :passporting, passporting)
    end

    context "with passporting" do
      let(:passporting) { true }

      it "skips income when passporting set true" do
        click_on "Save and continue"
        expect(page).to have_content "Property Page Template"
        click_on "Back"
        expect(page).to have_content "Intro Page Template"
      end
    end

    context "without passporting" do
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
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Please select at least one option")
        end
      end

      it "allows no income to be selected" do
        click_checkbox("monthly-income-form-monthly-incomes", "none")
        click_on "Save and continue"
        expect(page).not_to have_css(".govuk-error-summary__list")
      end
    end
  end

  def click_checkbox(form_name, field)
    fieldname = field.to_s.tr("_", "-")
    find("label[for=#{form_name}-#{fieldname}-field]").click
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
