require "rails_helper"

RSpec.describe CalculationResult do
  it "raises an error if there's an unknown result" do
    expect { described_class.new({}).decision }.to raise_error("Unhandled CFE result: ")
  end

  it "works out disregard from net equity minus assessed equity" do
    data = {
      assessment: {
        capital: {
          capital_items: {
            properties: {
              main_home: {
                value: 20.0,
                outstanding_mortgage: 9.0,
                net_equity: "11.0",
                assessed_equity: "1.0",
              },
            },
          },
        },
      },
    }

    expect(described_class.new(data).client_main_home_rows[:disregard]).to eq "-£10.00"
  end
end
