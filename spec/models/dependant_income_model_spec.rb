require "rails_helper"

RSpec.describe DependantIncomeModel do
  context "when before 8th April 2024" do
    before do
      travel_to Date.new(2024, 4, 7)
    end

    it "has new dependant limits" do
      expect(described_class.dependant_income_upper_limits).to eq({ "every_four_weeks" => 311.97,
                                                                    "every_two_weeks" => 155.99,
                                                                    "every_week" => 77.99,
                                                                    "monthly" => 338.9,
                                                                    "three_months" => 1016.70 })
    end
  end

  context "when after 8th April 2024" do
    before do
      travel_to Date.new(2024, 4, 8)
    end

    it "has new dependant limits" do
      expect(described_class.dependant_income_upper_limits).to eq({ "every_four_weeks" => 332.96,
                                                                    "every_two_weeks" => 166.48,
                                                                    "every_week" => 83.24,
                                                                    "monthly" => 361.70,
                                                                    "three_months" => 1085.10 })
    end
  end
end
