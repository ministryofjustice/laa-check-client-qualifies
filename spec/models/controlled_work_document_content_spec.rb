require "rails_helper"

RSpec.describe ControlledWorkDocumentContent do
  describe "#from_cfe_payload" do
    it "can handle paths with numbers in them" do
      session_data = {
        "api_response" => {
          "foo" => [
            { "bar" => 0 },
            { "bar" => 56 },
            { "bar" => 0 },
          ],
        },
      }
      expect(described_class.new(session_data).from_cfe_payload("foo.1.bar")).to eq 56
    end
  end

  describe "#main_home_percentage_owned" do
    it "takes into account partner percentage owned" do
      session_data = {
        "property_owned" => "outright",
        "partner" => true,
        "joint_ownership" => true,
        "percentage_owned" => 53,
        "joint_percentage_owned" => 25,
      }
      expect(described_class.new(session_data).main_home_percentage_owned).to eq 78
    end
  end

  context "when there are percentages" do
    def make_capital(percentage_owned)
      {
        "capital_items" => {
          "properties" => {
            "additional_properties" => [
              { "percentage_owned" => percentage_owned },
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

      it "returns 'unknown' if it differs" do
        session_data = {
          "api_response" => {
            "assessment" => {
              "capital" => make_capital(50),
              "partner_capital" => make_capital(51),
            },
          },
        }
        expect(described_class.new(session_data).additional_properties_percentage_owned).to eq "Unknown"
      end

      it "returns nil if client's additional property is smod" do
        session_data = {
          "in_dispute" => %w[property],
          "api_response" => {
            "assessment" => {
              "capital" => make_capital(50),
              "partner_capital" => make_capital(51),
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
        "property_owned" => "outright",
        "partner" => true,
        "joint_ownership" => false,
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
      it "returns zero" do
        expect(described_class.new(session_data).client_rent).to eq 0
      end
    end

    describe "#partner_rent" do
      it "returns zero" do
        expect(described_class.new(session_data).partner_rent).to eq 0
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
        expect(described_class.new(session_data).client_mortgage).to eq 0
      end
    end

    describe "#partner_mortgage" do
      it "returns zero" do
        expect(described_class.new(session_data).partner_mortgage).to eq 0
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

  describe "client assets" do
    describe "assets in dispute" do
      session_data = {
        "in_dispute" => %w[savings valuables investments property],
      }

      describe "#non_smod_client_savings" do
        it "returns nil" do
          expect(described_class.new(session_data).non_smod_client_savings).to eq nil
        end
      end

      describe "#non_smod_client_investments" do
        it "returns nil" do
          expect(described_class.new(session_data).non_smod_client_investments).to eq nil
        end
      end

      describe "#client_valuables" do
        it "returns nil" do
          expect(described_class.new(session_data).non_smod_client_valuables).to eq nil
        end
      end

      context "when in_dispute is nil" do
        session_data = {
          "in_dispute" => nil,
        }

        it "additional_property_in_dispute returns false" do
          expect(described_class.new(session_data)).not_to be_additional_property_in_dispute
        end

        it "savings_in_dispute returns false" do
          expect(described_class.new(session_data)).not_to be_savings_in_dispute
        end

        it "investments_in_dispute returns false" do
          expect(described_class.new(session_data)).not_to be_investments_in_dispute
        end

        it "valuables_in_dispute returns false" do
          expect(described_class.new(session_data)).not_to be_valuables_in_dispute
        end
      end
    end

    describe "assets not in dispute" do
      session_data = {
        "in_dispute" => %w[],
        "savings" => 400,
        "investments" => 100,
        "valuables" => 200,
      }

      describe "#client_savings" do
        it "returns value" do
          expect(described_class.new(session_data).non_smod_client_savings).to eq 400
        end
      end

      describe "#client_investments" do
        it "returns value" do
          expect(described_class.new(session_data).non_smod_client_investments).to eq 100
        end
      end

      describe "#client_valuables" do
        it "returns value" do
          expect(described_class.new(session_data).non_smod_client_valuables).to eq 200
        end
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

  context "when a session with everything is created the method" do
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
    end
  end

  context "when client_capital is not relevant the method" do
    before do
      allow(Steps::Helper).to receive(:valid_step?).and_return(false)
    end

    describe "#combined_non_disputed_capital?" do
      let(:session_data) { FactoryBot.build(:full_session) }

      it "returns nil" do
        expect(described_class.new(session_data).combined_non_disputed_capital).to eq nil
      end
    end
  end
end
