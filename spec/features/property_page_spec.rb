require "rails_helper"

RSpec.describe "Property Page" do
  let(:check_answers_header) { "Check your answers" }
  let(:property_entry_header) { "How much is the home they live in worth?" }
  let(:partner_property_entry_header) { "How much is the home worth?" }
  let(:property_header) { I18n.t("estimate_flow.property.legend") }
  let(:vehicle_header) { "Does your client own a vehicle?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, api_result: CalculationResult.new(build(:api_result)), create_assessment_id: estimate_id) }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    allow(mock_connection).to receive(:create_proceeding_type)
    allow(mock_connection).to receive(:create_regular_payments)
    allow(mock_connection).to receive(:create_applicant)
  end

  context "with partner", :partner_flag do
    let(:partner) { true }
    let(:expected_main_home) do
      { outstanding_mortgage: mortgage,
        percentage_owned: expected_share,
        shared_with_housing_assoc: false,
        value: 100_000 }
    end

    before do
      allow(mock_connection).to receive(:create_partner)
    end

    context "without main client dwelling" do
      context "without dwelling" do
        before do
          visit_check_answers(passporting: false)
        end

        it "doesn't send a main dwelling" do
          click_on "Submit"
        end
      end
    end

    context "when client owns main dwelling" do
      let(:mortgage) { 50_000 }
      let(:expected_share) { 50 }

      before do
        visit_check_answers(passporting: false, partner:) do |step|
          case step
          when :property
            select_radio_value("property-form", "property-owned", "with_mortgage")
            click_on "Save and continue"
            fill_in "client-property-entry-form-house-value-field", with: 100_000
            fill_in "client-property-entry-form-mortgage-field", with: mortgage
            fill_in "client-property-entry-form-percentage-owned-field", with: 50
          end
        end
      end

      it "submits 50% share" do
        expect(mock_connection)
          .to receive(:create_properties)
                .with(estimate_id,
                      { main_home: expected_main_home })
        click_on "Submit"
      end
    end
  end

  context "without partner" do
    let(:partner) { false }

    context "when on property form" do
      before do
        visit_flow_page(passporting: true, target: :property)
      end

      it "shows the correct form" do
        expect(page).to have_content property_header
      end

      it "sets error on property form" do
        click_on "Save and continue"
        expect(page).to have_css(".govuk-error-summary__list")
        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select if your client owns the home they live in")
        end
      end
    end

    context "with a mortgage" do
      before do
        visit_flow_page(passporting: true, target: :property)
        select_radio_value("property-form", "property-owned", "with_mortgage")
        click_on "Save and continue"
      end

      it "shows the property entry screen" do
        expect(page).to have_content property_entry_header
      end

      it "applies validation on the property entry form" do
        click_on "Save and continue"
        within ".govuk-error-summary__list" do
          expect(page).to have_content I18n.t("activemodel.errors.models.client_property_entry_form.attributes.house_value.blank")
          expect(page).to have_content I18n.t("activemodel.errors.models.client_property_entry_form.attributes.mortgage.blank")
          expect(page).to have_content I18n.t("activemodel.errors.models.client_property_entry_form.attributes.percentage_owned.blank")
        end
      end
    end

    context "with a property" do
      before do
        visit_check_answers(passporting: true) do |step|
          case step
          when :property
            select_radio_value("property-form", "property-owned", "with_mortgage")
            click_on "Save and continue"
            fill_in "client-property-entry-form-house-value-field", with: 100_000
            fill_in "client-property-entry-form-mortgage-field", with: 50_000
            fill_in "client-property-entry-form-percentage-owned-field", with: 37
            click_checkbox("client-property-entry-form-house-in-dispute", "true")
          end
        end
      end

      it "can be changed via check answers" do
        within("#subsection-property-header") { click_on "Change" }
        select_radio_value("property-form", "property-owned", "none")
        click_on "Save and continue"
        expect(page).to have_content check_answers_header
        within "#field-list-property" do
          expect(page).not_to have_content "Disputed asset"
          expect(page).not_to have_content "Estimated value"
        end
      end

      it "creates a single property in dispute" do
        allow(mock_connection).to receive(:api_result).and_return(CalculationResult.new(build(:api_result)))
        expect(mock_connection)
          .to receive(:create_properties)
                .with(estimate_id, { main_home: { outstanding_mortgage: 50_000,
                                                  percentage_owned: 37,
                                                  value: 100_000,
                                                  shared_with_housing_assoc: false,
                                                  subject_matter_of_dispute: true } })

        expect(page).to have_content check_answers_header
        within "#field-list-property" do
          expect(page).to have_content "Disputed asset"
        end

        click_on "Submit"
      end
    end
  end

  context "with controlled", :controlled_flag do
    context "without partner" do
      before do
        visit_flow_page(controlled: true, passporting: true, target: :property)
      end

      it "shows controlled guidance" do
        expect(page).to have_link(href: I18n.t("generic.smod.guidance.controlled.link"))
      end
    end
  end
end
