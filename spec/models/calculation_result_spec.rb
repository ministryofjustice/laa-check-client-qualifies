require "rails_helper"

RSpec.describe CalculationResult do
  it "raises an error if there's an unknown result" do
    expect { described_class.new({}).decision }.to raise_error("Unhandled CFE result: ")
  end

  it "works out disregard from net equity minus assessed equity" do
    data = FactoryBot.build(
      :api_result,
      main_home: FactoryBot.build(:property_api_result, net_equity: 20, assessed_equity: 10),
    )

    expect(described_class.new(data).client_main_home_rows[:disregard]).to eq "-£10.00"
  end
end
