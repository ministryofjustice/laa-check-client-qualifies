require "rails_helper"

RSpec.describe ControlledWorkDocumentContent do
  context "when there are percentages" do
    def make_capital(percentage_owned, subject_matter_of_dispute: false)
      {
        "capital_items" => {
          "properties" => {
            "additional_properties" => [
              { "percentage_owned" => percentage_owned,
                "subject_matter_of_dispute" => subject_matter_of_dispute },
            ],
          },
        },
      }
    end

    describe "#additional_properties_percentage_owned" do
      it "returns the percentage owned if it's always the same" do
        session_data = {
          "api_response" => {
            "assessment" => {
              "capital" => make_capital(50),
              "partner_capital" => make_capital(50),
            },
          },
        }
        expect(described_class.new(session_data).additional_properties_percentage_owned).to eq 50
      end

      it "returns an empty string if it differs" do
        session_data = {
          "api_response" => {
            "assessment" => {
              "capital" => make_capital(50),
              "partner_capital" => make_capital(51),
            },
          },
        }
        expect(described_class.new(session_data).additional_properties_percentage_owned).to eq ""
      end

      it "returns nil if client's additional property is smod" do
        session_data = {
          "api_response" => {
            "assessment" => {
              "capital" => make_capital(50, subject_matter_of_dispute: true),
            },
          },
        }
        expect(described_class.new(session_data).non_smod_additional_properties_percentage_owned).to eq nil
      end
    end
  end

  context "when the main home is owned" do
    let(:session_data) do
      {
        "property_owned" => "with_mortgage",
        "partner" => true,
        "percentage_owned" => 100,
        "api_response" => {
          "result_summary" => {
            "disposable_income" => {
              "net_housing_costs" => 43.2,
            },
            "partner_disposable_income" => {
              "net_housing_costs" => 44,
            },
          },
        },
      }
    end

    describe "#client_mortgage" do
      it "returns housing costs" do
        expect(described_class.new(session_data).client_mortgage).to eq 43.2
      end
    end

    describe "#partner_mortgage" do
      it "returns housing costs" do
        expect(described_class.new(session_data).partner_mortgage).to eq 44
      end
    end

    describe "#client_rent" do
      it "returns nil" do
        expect(described_class.new(session_data).client_rent).to eq nil
      end
    end

    describe "#partner_rent" do
      it "returns nil" do
        expect(described_class.new(session_data).partner_rent).to eq nil
      end
    end
  end

  context "when the main home is rented" do
    let(:session_data) do
      {
        "property_owned" => "nont",
        "partner" => true,
        "api_response" => {
          "result_summary" => {
            "disposable_income" => {
              "net_housing_costs" => 43.2,
            },
            "partner_disposable_income" => {
              "net_housing_costs" => 44,
            },
          },
        },
      }
    end

    describe "#client_mortgage" do
      it "returns zero" do
        expect(described_class.new(session_data).client_mortgage).to eq nil
      end
    end

    describe "#partner_mortgage" do
      it "returns zero" do
        expect(described_class.new(session_data).partner_mortgage).to eq nil
      end
    end

    describe "#client_rent" do
      it "returns housing costs" do
        expect(described_class.new(session_data).client_rent).to eq 43.20
      end
    end

    describe "#partner_rent" do
      it "returns housing costs" do
        expect(described_class.new(session_data).partner_rent).to eq 44
      end
    end
  end

  describe "#house_in_dispute?" do
    context "when the house is in dispute" do
      let(:session_data) do
        build(:minimal_complete_session,
              :with_main_home,
              house_in_dispute: true,
              api_response: FactoryBot.build(:api_result,
                                             main_home: FactoryBot.build(:property_api_result,
                                                                         value: 200,
                                                                         outstanding_mortgage: 105,
                                                                         net_equity: 10,
                                                                         assessed_equity: 20,
                                                                         percentage_owned: 100,
                                                                         net_value: 95)).with_indifferent_access)
      end

      describe "smod methods" do
        describe "#smod_main_home_value" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_value).to eq 200
          end
        end

        describe "smod_main_home_outstanding_mortgage" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_outstanding_mortgage).to eq 105
          end
        end

        describe "smod_main_home_percentage_owned" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_percentage_owned).to eq 100
          end
        end

        describe "smod_main_home_net_value" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_net_value).to eq 95
          end
        end

        describe "smod_main_home_net_equity" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_net_equity).to eq 10
          end
        end

        describe "smod_main_home_assessed_equity" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_assessed_equity).to eq 20
          end
        end
      end
    end

    context "when the house is not in dispute" do
      let(:session_data) do
        build(:minimal_complete_session,
              :with_main_home,
              house_in_dispute: false,
              api_response: FactoryBot.build(:api_result,
                                             main_home: FactoryBot.build(:property_api_result,
                                                                         value: 200,
                                                                         outstanding_mortgage: 105,
                                                                         net_equity: 10,
                                                                         assessed_equity: 20,
                                                                         percentage_owned: 100,
                                                                         net_value: 95)).with_indifferent_access)
      end

      describe "smod methods" do
        describe "#smod_main_home_value" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_value).to eq nil
          end
        end

        describe "smod_main_home_outstanding_mortgage" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_outstanding_mortgage).to eq nil
          end
        end

        describe "smod_main_home_percentage_owned" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_percentage_owned).to eq nil
          end
        end

        describe "smod_main_home_net_value" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_net_value).to eq nil
          end
        end

        describe "smod_main_home_assessed_equity" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_assessed_equity).to eq nil
          end
        end

        describe "smod_main_home_net_equity" do
          it "returns a response" do
            expect(described_class.new(session_data).smod_main_home_net_equity).to eq nil
          end
        end
      end
    end
  end

  context "when there is a full session of data" do
    let(:session_data) { FactoryBot.build(:full_session) }

    context "when asylum support exists" do
      let(:session_data) do
        build(:minimal_complete_session,
              :with_asylum_support,
              api_response: FactoryBot.build(:api_result).with_indifferent_access)
      end

      describe "#smod_assets?" do
        it "returns no response" do
          expect(described_class.new(session_data).smod_assets?).to eq nil
        end
      end

      describe "#combined_non_disputed_capital?" do
        it "returns nil" do
          expect(described_class.new(session_data).combined_non_disputed_capital).to eq nil
        end
      end
    end

    context "when capital is in dispute" do
      let(:session_data) do
        build(:minimal_complete_session,
              :with_main_home,
              house_in_dispute: true,
              api_response:
                FactoryBot.build(
                  :api_result,
                  result_summary: build(
                    :result_summary,
                    capital: build(:capital_summary,
                                   combined_disputed_capital: 4356),
                  ),
                ).with_indifferent_access)
      end

      describe "#smod_total_capital" do
        it "returns a response" do
          expect(described_class.new(session_data).smod_total_capital).to eq 4356
        end
      end
    end

    context "when capital is not in dispute" do
      let(:session_data) do
        build(:minimal_complete_session,
              :with_main_home,
              :with_partner,
              api_response:
                FactoryBot.build(:api_result,
                                 main_home: FactoryBot.build(:property_api_result, value: 123_000),
                                 additional_property: FactoryBot.build(:property_api_result,
                                                                       outstanding_mortgage: 120_000,
                                                                       percentage_owned: 75)).with_indifferent_access)
      end

      describe "#main_home_value" do
        it "returns a response" do
          expect(described_class.new(session_data).main_home_value).to eq 123_000
        end
      end

      describe "#main_home_net_value" do
        it "returns a response" do
          expect(described_class.new(session_data).main_home_net_value).to eq 110_000
        end
      end

      describe "#main_home_outstanding_mortgage" do
        it "returns a response" do
          expect(described_class.new(session_data).main_home_outstanding_mortgage).to eq 90_000
        end
      end

      describe "#main_home_percentage_owned" do
        it "returns a response" do
          expect(described_class.new(session_data).main_home_percentage_owned).to eq 100
        end
      end

      describe "#main_home_net_equity" do
        it "returns a response" do
          expect(described_class.new(session_data).main_home_net_equity).to eq 110_000
        end
      end

      describe "#main_home_assessed_equity" do
        it "returns a response" do
          expect(described_class.new(session_data).main_home_assessed_equity).to eq 100_000
        end
      end

      describe "#additional_properties_value" do
        it "returns a response" do
          expect(described_class.new(session_data).additional_properties_value).to eq 200_000
        end
      end

      describe "#additional_properties_mortgage" do
        it "returns a response" do
          expect(described_class.new(session_data).additional_properties_mortgage).to eq 120_000
        end
      end

      describe "#non_smod_additional_properties_mortgage" do
        it "returns the correct figure" do
          expect(described_class.new(session_data).non_smod_additional_properties_mortgage).to eq 120_000
        end
      end
    end
  end

  describe "#dependants_allowance_under_16" do
    let(:session_data) do
      {
        child_dependants:,
        child_dependants_count: 1,
        api_response: FactoryBot.build(:api_result,
                                       result_summary: build(:result_summary,
                                                             disposable_income: build(:disposable_income_summary,
                                                                                      dependant_allowance_under_16: 3))),
      }.with_indifferent_access
    end

    context "when client has child dependants without income" do
      let(:child_dependants) { true }

      it "returns the payload value" do
        expect(described_class.new(session_data).dependants_allowance_under_16).to eq 3
      end
    end

    context "when client has child dependants but they all have income" do
      let(:session_data) do
        {
          child_dependants: true,
          child_dependants_count: 1,
          adult_dependants: true,
          adult_dependants_count: 1,
          dependants_get_income: true,
          dependant_incomes: [
            { amount: 1, frequency: "weekly" },
            { amount: 1, frequency: "weekly" },
          ],
          api_response: FactoryBot.build(:api_result,
                                         result_summary: build(:result_summary,
                                                               disposable_income: build(:disposable_income_summary,
                                                                                        dependant_allowance_under_16: 3))),
        }.with_indifferent_access
      end

      it "returns the payload value" do
        expect(described_class.new(session_data).dependants_allowance_under_16).to eq 3
      end
    end
  end

  describe "#dependants_allowance_over_16" do
    let(:session_data) do
      {
        adult_dependants:,
        api_response: FactoryBot.build(:api_result,
                                       result_summary: build(:result_summary,
                                                             disposable_income: build(:disposable_income_summary,
                                                                                      dependant_allowance_over_16: 3))),
      }.with_indifferent_access
    end

    context "when client has adult dependants" do
      let(:adult_dependants) { true }

      it "returns the payload value" do
        expect(described_class.new(session_data).dependants_allowance_over_16).to eq 3
      end
    end
  end

  describe "#client_tax_and_national_insurance" do
    let(:session_data) do
      {
        employment_status:,
        api_response: FactoryBot.build(:api_result,
                                       result_summary: build(:result_summary,
                                                             disposable_income: build(:disposable_income_summary,
                                                                                      employment_income: { tax: 3 }))),
      }.with_indifferent_access
    end

    context "when client is employed" do
      let(:employment_status) { "in_work" }

      it "returns the payload value, minused" do
        expect(described_class.new(session_data).client_tax_and_national_insurance).to eq(-3)
      end
    end
  end

  describe "#partner_tax_and_national_insurance" do
    let(:session_data) do
      {
        partner: true,
        partner_employment_status:,
        api_response: FactoryBot.build(:api_result,
                                       result_summary: build(:result_summary,
                                                             partner_disposable_income: build(:disposable_income_summary,
                                                                                              employment_income: { tax: 3 }))),
      }.with_indifferent_access
    end

    context "when partner is employed" do
      let(:partner_employment_status) { "in_work" }

      it "returns the payload value, minused" do
        expect(described_class.new(session_data).partner_tax_and_national_insurance).to eq(-3)
      end
    end
  end

  describe "#client_employment_deduction" do
    let(:session_data) do
      {
        employment_status:,
        api_response: FactoryBot.build(:api_result,
                                       result_summary: build(:result_summary,
                                                             disposable_income: build(:disposable_income_summary,
                                                                                      employment_income: { fixed_employment_deduction: 3 }))),
      }.with_indifferent_access
    end

    context "when client is employed" do
      let(:employment_status) { "in_work" }

      it "returns the payload value, minused" do
        expect(described_class.new(session_data).client_employment_deduction).to eq(-3)
      end
    end
  end

  describe "#partner_employment_deduction" do
    let(:session_data) do
      {
        partner: true,
        partner_employment_status:,
        api_response: FactoryBot.build(:api_result,
                                       result_summary: build(:result_summary,
                                                             partner_disposable_income: build(:disposable_income_summary,
                                                                                              employment_income: { fixed_employment_deduction: 3 }))),
      }.with_indifferent_access
    end

    context "when partner is employed" do
      let(:partner_employment_status) { "in_work" }

      it "returns the payload value, minused" do
        expect(described_class.new(session_data).partner_employment_deduction).to eq(-3)
      end
    end
  end

  describe "#combined_childcare_costs" do
    let(:session_data) do
      {
        child_dependants:,
        student_finance_value: 1,
        api_response: FactoryBot.build(:api_result,
                                       assessment: build(:assessment,
                                                         disposable_income: { childcare_allowance: 3 })),
      }.with_indifferent_access
    end

    context "when eligible for costs" do
      let(:child_dependants) { true }

      it "returns the payload value" do
        expect(described_class.new(session_data).combined_childcare_costs).to eq(3)
      end
    end
  end
end
