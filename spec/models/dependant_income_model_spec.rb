require "rails_helper"

RSpec.describe DependantIncomeModel do
  context "when after 8th April 2024" do
    it "has new dependant limits" do
      expect(described_class.dependant_income_upper_limits).to eq({ "every_four_weeks" => 332.96,
                                                                    "every_two_weeks" => 166.48,
                                                                    "every_week" => 83.24,
                                                                    "monthly" => 361.70,
                                                                    "three_months" => 1085.10 })
    end
  end
end
