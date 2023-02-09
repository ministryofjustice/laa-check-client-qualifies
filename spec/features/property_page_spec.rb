require "rails_helper"

RSpec.describe "Property Page" do
  let(:check_answers_header) { "Check your answers" }
  let(:property_entry_header) { "How much is the home they live in worth?" }
  let(:partner_property_entry_header) { "How much is the home worth?" }
  let(:property_header) { "Does your client own the home they live in?" }
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

      context "when partner owns main dwelling" do
        context "with mortgage" do
          let(:expected_share) { 40 }
          let(:mortgage) { 50_000 }

          context "without a value" do
            before do
              visit_flow_page(passporting: false, partner: true, target: :partner_property)

              select_radio_value("partner-property-form", "property-owned", "with_mortgage")
              click_on "Save and continue"
              fill_in "partner-property-entry-form-house-value-field", with: 100_000
              fill_in "partner-property-entry-form-percentage-owned-field", with: 40
            end

            it "errors" do
              click_on "Save and continue"
              within ".govuk-error-summary__list" do
                expect(page).to have_content("Enter the outstanding mortgage on the home")
              end
            end
          end

          context "with a value" do
            before do
              visit_check_answers(passporting: false, partner: true) do |step|
                case step
                when :partner_property
                  select_radio_value("partner-property-form", "property-owned", "with_mortgage")
                  click_on "Save and continue"
                  fill_in "partner-property-entry-form-house-value-field", with: 100_000
                  fill_in "partner-property-entry-form-percentage-owned-field", with: 40
                  fill_in "partner-property-entry-form-mortgage-field", with: mortgage
                end
              end
            end

            it "submits the partner asset as the main home" do
              expect(mock_connection)
                .to receive(:create_properties)
                      .with(estimate_id,
                            { main_home: expected_main_home })
              click_on "Submit"
            end

            it "can do a check answers loop, changing mortgage to N/A" do
              within "#subsection-partner_property-header" do
                click_on "Change"
              end
              select_radio_value("partner-property-form", "property-owned", "outright")
              click_on "Save and continue"
              click_on "Save and continue"
              within "#field-list-partner_property" do
                expect(find("#outstanding-mortgage")).to have_content("Outstanding mortgageNot applicable")
              end
            end
          end
        end

        context "without mortgage" do
          before do
            visit_check_answers(passporting: false, partner: true) do |step|
              case step
              when :partner_property
                select_radio_value("partner-property-form", "property-owned", "outright")
                click_on "Save and continue"
                fill_in "partner-property-entry-form-house-value-field", with: 100_000
                fill_in "partner-property-entry-form-percentage-owned-field", with: 40
              end
            end
          end

          let(:expected_share) { 40 }
          let(:mortgage) { 0 }

          it "submits the partner asset as the main home" do
            expect(mock_connection)
              .to receive(:create_properties)
                    .with(estimate_id,
                          { main_home: expected_main_home })

            click_on "Submit"
          end
        end
      end
    end

    context "when client owns main dwelling" do
      let(:mortgage) { 50_000 }

      context "without shared ownership" do
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
              choose("No")
            # partner property question skipped in this case
            when :partner_property
              true
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

      context "without a partner percentage" do
        before do
          visit_flow_page(passporting: true, partner:, target: :property)
          select_radio_value("property-form", "property-owned", "with_mortgage")
          click_on "Save and continue"
          fill_in "client-property-entry-form-house-value-field", with: 100_000
          fill_in "client-property-entry-form-mortgage-field", with: mortgage
          fill_in "client-property-entry-form-percentage-owned-field", with: 50
          choose("Yes")
        end

        it "errors" do
          click_on "Save and continue"
          within ".govuk-error-summary__list" do
            expect(page).to have_content("Enter the percentage that the partner owns of the home")
          end
        end
      end

      context "when percentage exceeded 100" do
        before do
          visit_flow_page(passporting: true, partner:, target: :property)
          select_radio_value("property-form", "property-owned", "with_mortgage")
          click_on "Save and continue"
          fill_in "client-property-entry-form-house-value-field", with: 100_000
          fill_in "client-property-entry-form-mortgage-field", with: mortgage
          fill_in "client-property-entry-form-percentage-owned-field", with: 50
          choose("Yes")
          fill_in "client-property-entry-form-joint-percentage-owned-field", with: 51
        end

        it "errors" do
          click_on "Save and continue"
          within ".govuk-error-summary__list" do
            expect(page).to have_content(I18n.t("activemodel.errors.models.client_property_entry_form.attributes.joint_percentage_owned.cannot_exceed_100"))
          end
        end
      end

      context "with shared ownership" do
        let(:expected_share) { 70 }

        before do
          visit_check_answers(passporting: false, partner:) do |step|
            case step
            when :property
              select_radio_value("property-form", "property-owned", "with_mortgage")
              click_on "Save and continue"
              fill_in "client-property-entry-form-house-value-field", with: 100_000
              fill_in "client-property-entry-form-mortgage-field", with: mortgage
              fill_in "client-property-entry-form-percentage-owned-field", with: 50
              choose("Yes")
              fill_in "client-property-entry-form-joint-percentage-owned-field", with: 20
            when :partner_property
              true
            end
          end
        end

        it "submits 70% share" do
          expect(mock_connection)
            .to receive(:create_properties)
                  .with(estimate_id,
                        { main_home: expected_main_home })
          click_on "Submit"
        end
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

    context "with partner", :partner_flag do
      before do
        visit_flow_page(controlled: true, passporting: true, partner: true, target: :partner_property)
      end

      it "shows controlled guidance" do
        expect(page).to have_link(href: I18n.t("generic.trapped_capital.controlled_link"))
      end
    end
  end
end
