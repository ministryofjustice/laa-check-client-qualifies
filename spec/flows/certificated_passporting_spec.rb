require "rails_helper"

RSpec.describe "Certificated, passported flow", :calls_cfe_early_returns_not_ineligible, type: :feature do
  before do
    start_assessment
  end

  describe "check answers screen" do
    let(:income_section_text) { "Client income" }

    before do
      fill_in_client_age_screen
      fill_in_level_of_help_screen
      fill_in_domestic_abuse_applicant_screen
      fill_in_immigration_or_asylum_type_upper_tribunal_screen
    end

    context "with passporting" do
      before do
        fill_in_applicant_screen(passporting: "Yes")
        fill_in_property_screen
        fill_in_additional_property_screen
        fill_in_assets_screen
        fill_in_vehicle_screen
        confirm_screen(:check_answers)
      end

      it "doesnt show income section" do
        expect(page).not_to have_content(income_section_text)
      end

      it "shows correct sections" do
        expect(all(".govuk-summary-card__title").map(&:text))
          .to eq(
            ["Client age",
             "Partner and passporting",
             "Level of help",
             "Type of matter",
             "Type of immigration or asylum matter",
             "Home client usually lives in",
             "Client other property",
             "Client assets",
             "Vehicles"],
          )
      end
    end

    context "without passporting" do
      before do
        fill_in_applicant_screen(passporting: "No")
        fill_in_forms_until(:check_answers)
      end

      it "shows income section as questions have been asked" do
        expect(page).to have_content(income_section_text)
      end

      it "shows correct sections" do
        expect(all(".govuk-summary-card__title").map(&:text))
          .to eq(
            ["Client age",
             "Partner and passporting",
             "Level of help",
             "Type of matter",
             "Type of immigration or asylum matter",
             "Number of dependants",
             "Employment status",
             "Client benefits",
             "Client other income",
             "Client outgoings and deductions",
             "Home client usually lives in",
             "Housing costs",
             "Client other property",
             "Client assets",
             "Vehicles"],
          )
      end
    end
  end

  it "asks for property details if relevant" do
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_forms_until(:property)
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_property_entry_screen
    confirm_screen("additional_property")
  end

  it "asks for additional property details if relevant" do
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_forms_until(:additional_property)
    fill_in_additional_property_screen(choice: "Yes, owned outright")
    fill_in_additional_property_details_screen
    confirm_screen("assets")
  end

  it "asks for vehicle details if vehicle owned" do
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    confirm_screen(:check_answers)
  end
end
