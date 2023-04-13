require "rails_helper"

RSpec.describe CalculationResult do
  it "raises an error if there's an unknown result" do
    expect { described_class.new("api_response" => {}).decision }.to raise_error("Unhandled CFE result: ")
  end

  it "ignores zero-value 'main home' items" do
    data = FactoryBot.build(
      :api_result,
      main_home: FactoryBot.build(:property_api_result, value: 0),
    )

    expect(described_class.new("api_response" => data).client_owns_main_home?).to eq false
  end

  describe "#client_main_home_rows" do
    it "does not show cost of sale deduction row in situations where cost of sale deduction is zero" do
      data = FactoryBot.build(
        :api_result,
        main_home: FactoryBot.build(:property_api_result, transaction_allowance: 0),
      )

      expect(described_class.new("api_response" => data).main_home_data[:rows].keys).not_to include(:transaction_allowance)
    end

    it "does shows cost of sale deduction row in situations where cost of sale deduction is not zero" do
      data = FactoryBot.build(
        :api_result,
        main_home: FactoryBot.build(:property_api_result, transaction_allowance: 1),
      )

      expect(described_class.new("api_response" => data).main_home_data[:rows].keys).to include(:transaction_allowance)
    end
  end

  describe "#client_additional_property_rows" do
    it "does not show cost of sale deduction row in situations where cost of sale deduction is zero" do
      data = FactoryBot.build(
        :api_result,
        additional_property: FactoryBot.build(:property_api_result, transaction_allowance: 0),
      )

      expect(described_class.new("api_response" => data).client_additional_property_data[:rows].keys).not_to include(:transaction_allowance)
    end

    it "does shows cost of sale deduction row in situations where cost of sale deduction is not zero" do
      data = FactoryBot.build(
        :api_result,
        additional_property: FactoryBot.build(:property_api_result, transaction_allowance: 1),
      )

      expect(described_class.new("api_response" => data).client_additional_property_data[:rows].keys).to include(:transaction_allowance)
    end
  end
end
