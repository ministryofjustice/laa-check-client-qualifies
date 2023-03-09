require "rails_helper"

RSpec.describe CalculationResult do
  it "raises an error if there's an unknown result" do
    expect { described_class.new({}).decision }.to raise_error("Unhandled CFE result: ")
  end

  it "ignores zero-value 'main home' items" do
    data = FactoryBot.build(
      :api_result,
      main_home: FactoryBot.build(:property_api_result, value: 0),
    )

    expect(described_class.new(data).client_owns_main_home?).to eq false
  end

  it "works out disregard from net equity minus assessed equity" do
    data = FactoryBot.build(
      :api_result,
      main_home: FactoryBot.build(:property_api_result, net_equity: 20, assessed_equity: 10),
    )

    expect(described_class.new(data).client_main_home_rows[:disregards]).to eq "-£10.00"
  end

  describe "#client_main_home_rows" do
    it "does not show cost of sale deduction row in situations where cost of sale deduction is zero" do
      data = FactoryBot.build(
        :api_result,
        main_home: FactoryBot.build(:property_api_result, transaction_allowance: 0),
      )

      expect(described_class.new(data).client_main_home_rows.keys).not_to include(:deductions)
    end

    it "does shows cost of sale deduction row in situations where cost of sale deduction is not zero" do
      data = FactoryBot.build(
        :api_result,
        main_home: FactoryBot.build(:property_api_result, transaction_allowance: 1),
      )

      expect(described_class.new(data).client_main_home_rows.keys).to include(:deductions)
    end
  end

  describe "#client_additional_property_rows" do
    it "does not show cost of sale deduction row in situations where cost of sale deduction is zero" do
      data = FactoryBot.build(
        :api_result,
        additional_property: FactoryBot.build(:property_api_result, transaction_allowance: 0),
      )

      expect(described_class.new(data).client_additional_property_rows.keys).not_to include(:deductions)
    end

    it "does shows cost of sale deduction row in situations where cost of sale deduction is not zero" do
      data = FactoryBot.build(
        :api_result,
        additional_property: FactoryBot.build(:property_api_result, transaction_allowance: 1),
      )

      expect(described_class.new(data).client_additional_property_rows.keys).to include(:deductions)
    end
  end

  describe "#additional_vehicle_rows" do
    it "can cope with multiple vehicles" do
      data = FactoryBot.build(
        :api_result,
        vehicles: FactoryBot.build_list(:vehicle_api_result, 2,
                                        value: 5_000,
                                        loan_amount_outstanding: 0,
                                        disregards_and_deductions: 1_000,
                                        assessed_value: 4_000),
      )

      expect(described_class.new(data).additional_vehicle_rows).to eq({
        disregards: "-£1,000.00",
        outstanding_payments: "£0.00",
        value: "£5,000.00",
      })
      expect(described_class.new(data).additional_vehicle_assessed_value).to eq "£4,000.00"
    end
  end

  describe "#household_outgoing_rows" do
    it "retrieves the right data" do
      data = {
        result_summary: {
          disposable_income: {
            net_housing_costs: 500.0,
          },
        },
      }

      expect(described_class.new(data).household_outgoing_rows[:housing_costs]).to eq "£500.00"
    end
  end
end
