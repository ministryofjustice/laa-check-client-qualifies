require "rails_helper"

RSpec.describe "Level of help page" do
  let(:level_of_help_header) { I18n.t("estimate_flow.level_of_help.title") }

  context "when controlled is not enabled" do
    it "does not show this page" do
      visit_first_page
      expect(page).not_to have_content level_of_help_header
    end
  end

  context "when controlled is enabled", :controlled_flag, :partner_flag do
    let(:mock_connection) do
      instance_double(CfeConnection, create_proceeding_type: nil, create_applicant: nil, api_result: calculation_result)
    end
    let(:calculation_result) { CalculationResult.new FactoryBot.build(:api_result) }
    let(:assets_header) { I18n.t("estimate_flow.assets.legend") }
    let(:partner_assets_header) { I18n.t("estimate_flow.partner_assets.legend") }

    it "shows this page first" do
      visit_first_page
      expect(page).to have_content level_of_help_header
    end

    it "shows an error if nothing is selected" do
      visit_first_page
      click_on "Save and continue"
      expect(page).to have_content level_of_help_header
      expect(page).to have_content "Select the level of help your client needs"
    end

    it "tells CFE if I choose controlled" do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      expect(mock_connection).to receive(:create_assessment_id).with({ submission_date: Time.zone.today, level_of_help: "controlled" })
      visit_check_answers(passporting: true) do |step|
        case step
        when :level_of_help
          select_radio(page:, form: "level-of-help-form", field: "level-of-help", value: "controlled")
          click_on "Save and continue"
        end
      end

      click_on "Submit"
    end

    it "skips the client vehicle screens if I choose controlled" do
      visit_flow_page(passporting: true, target: :property) do |step|
        case step
        when :level_of_help
          select_radio(page:, form: "level-of-help-form", field: "level-of-help", value: "controlled")
          click_on "Save and continue"
        end
      end

      select_radio(page:, form: "property-form", field: "property-owned", value: "none")
      click_on "Save and continue"
      expect(page).to have_content assets_header
    end

    it "skips the partner vehicle screens if I choose controlled" do
      visit_flow_page(passporting: true, partner: true, target: :partner_property) do |step|
        case step
        when :level_of_help
          select_radio(page:, form: "level-of-help-form", field: "level-of-help", value: "controlled")
          click_on "Save and continue"
        end
      end

      select_radio(page:, form: "partner-property-form", field: "property-owned", value: "none")
      click_on "Save and continue"
      expect(page).to have_content partner_assets_header
    end

    it "shows different outgoings guidance text if I select controlled" do
      visit_flow_page(passporting: false, target: :outgoings) do |step|
        case step
        when :level_of_help
          select_radio(page:, form: "level-of-help-form", field: "level-of-help", value: "controlled")
          click_on "Save and continue"
        end
      end

      expect(page).not_to have_content "Guidance on outgoings"
      expect(page).to have_content "Guidance on determining disposable income"
    end
  end
end
