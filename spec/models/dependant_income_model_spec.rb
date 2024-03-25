require "rails_helper"

RSpec.describe DependantIncomeModel do
  context "when before 8th April 2024" do
    before do
      travel_to Date.new(2024, 3, 7)
    end

    it "has new dependant limits" do
      expect(described_class.dependant_income_upper_limits).to eq({ "every_four_weeks" => 312.83,
                                                                    "every_two_weeks" => 156.42,
                                                                    "every_week" => 78.21,
                                                                    "monthly" => 338.9,
                                                                    "three_months" => 1016.70 })
    end
  end

  context "when after 8th April 2024" do
    before do
      travel_to Date.new(2024, 4, 8)
    end

    it "has new dependant limits" do
      expect(described_class.dependant_income_upper_limits).to eq({ "every_four_weeks" => 333.88,
                                                                    "every_two_weeks" => 166.94,
                                                                    "every_week" => 83.47,
                                                                    "monthly" => 361.70,
                                                                    "three_months" => 1085.10 })
    end
  end
end
