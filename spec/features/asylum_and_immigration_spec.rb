require "rails_helper"

RSpec.describe "Asylum and immigration pages", :controlled_flag do
  let(:tribunal_header) { I18n.t("estimate_flow.tribunal.title") }
  let(:applicant_header) { I18n.t("estimate_flow.applicant.heading") }
  let(:matter_type_header) { I18n.t("estimate_flow.matter_type.title") }

  context "when asylum and immigration is not enabled" do
    it "does not show these pages" do
      visit_flow_page(target: :level_of_help, passporting: true)
      select_radio(page:, form: "level-of-help-form", field: "level-of-help", value: "controlled")
      click_on "Save and continue"
      expect(page).not_to have_content tribunal_header
    end
  end

  context "when a&i is enabled", :controlled_flag, :asylum_and_immigration_flag do
    let(:mock_connection) do
      instance_double(CfeConnection, create_assessment_id: estimate_id, create_applicant: nil, api_result: calculation_result)
    end
    let(:estimate_id) { SecureRandom.uuid }
    let(:calculation_result) { CalculationResult.new FactoryBot.build(:api_result) }

    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      visit_flow_page(target: :level_of_help, passporting: true)
      select_radio(page:, form: "level-of-help-form", field: "level-of-help", value: "controlled")
      click_on "Save and continue"
    end

    it "shows the tribunal page first" do
      expect(page).to have_content tribunal_header
    end

    it "shows an error if nothing is selected" do
      click_on "Save and continue"
      expect(page).to have_content tribunal_header
      expect(page).to have_content "Select yes if the case relates to proceedings in the Immigration and Asylum chamber of either the First-tier or Upper Tribunal"
    end

    it "takes me to the applicant page if I say no" do
      select_boolean_value("tribunal-form", :upper_tribunal, false)
      click_on "Save and continue"
      expect(page).to have_content applicant_header
    end

    it "takes me to the matter type page if I say yes" do
      select_boolean_value("tribunal-form", :upper_tribunal, true)
      click_on "Save and continue"
      expect(page).to have_content matter_type_header
    end

    it "shows an error if I don't choose a proceeding type" do
      select_boolean_value("tribunal-form", :upper_tribunal, true)
      click_on "Save and continue"
      click_on "Save and continue"
      expect(page).to have_content matter_type_header
      expect(page).to have_content "Select what type of matter this is"
    end

    it "sends what I choose to CFE" do
      select_boolean_value("tribunal-form", :upper_tribunal, true)
      click_on "Save and continue"
      select_radio(page:, form: "matter-type-form", field: "upper-tribunal-proceeding-type", value: "im030")
      click_on "Save and continue"

      expect(mock_connection).to receive(:create_proceeding_type).with(estimate_id, "IM030")

      select_boolean(page:, form_name: "applicant-form", field: :over_60, value: false)
      select_boolean(page:, form_name: "applicant-form", field: :passporting, value: true)
      select_boolean(page:, form_name: "applicant-form", field: :employed, value: true)
      click_on "Save and continue"
      select_radio(page:, form: "property-form", field: "property-owned", value: "none")
      click_on "Save and continue"
      fill_in "client-assets-form-savings-field", with: "0"
      fill_in "client-assets-form-investments-field", with: "0"
      fill_in "client-assets-form-valuables-field", with: "0"
      fill_in "client-assets-form-property-value-field", with: "0"
      click_on "Save and continue"
      click_on "Submit"
    end
  end
end
