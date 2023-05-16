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

  describe "#display_household_vehicles" do
    it "only returns the :value key when vehicle :in_regular_use is false" do
      data = FactoryBot.build(:api_result)

      expect(described_class.new("api_response" => data).display_household_vehicles.last).not_to include(:assessed_value,
                                                                                                         :disregards_and_deductions,
                                                                                                         :loan_amount_outstanding,
                                                                                                         :in_regular_use)
      expect(described_class.new("api_response" => data).display_household_vehicles.last).to include(:value)
      expect(described_class.new("api_response" => data).display_household_vehicles.first).not_to include(:date_of_purchase)
      expect(described_class.new("api_response" => data).display_household_vehicles.first).not_to include(:included_in_assessment)
    end

    it "shows other keys when in_regular_use is true" do
      data = FactoryBot.build(:api_result)

      expect(described_class.new("api_response" => data).display_household_vehicles.first).to include(:value,
                                                                                                      :assessed_value,
                                                                                                      :disregards_and_deductions,
                                                                                                      :loan_amount_outstanding,
                                                                                                      :in_regular_use)
      expect(described_class.new("api_response" => data).display_household_vehicles.first).not_to include(:date_of_purchase)
      expect(described_class.new("api_response" => data).display_household_vehicles.first).not_to include(:included_in_assessment)
    end
  end
end
