require "rails_helper"

RSpec.describe DependantIncomeModel do
  context "when before 7th April 2025" do
    let(:fixed_arbitrary_date) { Date.new(2025, 3, 17) }

    before { travel_to fixed_arbitrary_date }

    it "shows current dependant limits" do
      expect(described_class.dependant_income_upper_limits).to eq({ "every_four_weeks" => 333.88,
                                                                    "every_two_weeks" => 166.94,
                                                                    "every_week" => 83.47,
                                                                    "monthly" => 361.70,
                                                                    "three_months" => 1085.10 })
    end
  end

  context "when after 7th April 2025" do
    let(:fixed_arbitrary_date) { Date.new(2025, 4, 7) }

    before { travel_to fixed_arbitrary_date }

    it "shows new dependant limits" do
      expect(described_class.dependant_income_upper_limits).to eq({ "every_four_weeks" => 339.57,
                                                                    "every_two_weeks" => 169.79,
                                                                    "every_week" => 84.89,
                                                                    "monthly" => 367.87,
                                                                    "three_months" => 1103.61 })
    end
  end
end
