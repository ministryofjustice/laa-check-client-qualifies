require "rails_helper"

RSpec.describe CalculationResult do
  it "raises an error if there's an unknown result" do
    expect { described_class.new({}).decision }.to raise_error("Unhandled CFE result: ")
  end
end
