require "rails_helper"

RSpec.describe DependantIncomeModel do
  context "when before 6th April 2026" do
    let(:fixed_arbitrary_date) { Date.new(2026, 3, 17) }

    before { travel_to fixed_arbitrary_date }

    it "shows current dependant limits" do
      expect(described_class.dependant_income_upper_limits).to eq({ "every_four_weeks" => 339.57,
                                                                    "every_two_weeks" => 169.79,
                                                                    "every_week" => 84.89,
                                                                    "monthly" => 367.87,
                                                                    "three_months" => 1103.61 })
    end
  end

  context "when after 6th April 2026" do
    let(:fixed_arbitrary_date) { Date.new(2026, 4, 6) }

    before { travel_to fixed_arbitrary_date }

    it "shows new dependant limits" do
      expect(described_class.dependant_income_upper_limits).to eq({ "every_four_weeks" => 352.49,
                                                                    "every_two_weeks" => 176.24,
                                                                    "every_week" => 88.12,
                                                                    "monthly" => 381.86,
                                                                    "three_months" => 1145.58 })
    end
  end
end
