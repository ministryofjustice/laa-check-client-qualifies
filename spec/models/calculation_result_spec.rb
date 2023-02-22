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
end
