require "rails_helper"

RSpec.describe AssetsForm, type: :model do
  it "allows a zero mortgage value" do
    expect(described_class.new(savings: "0", investments: "0", valuables: "0", property_mortgage: "0", property_value: "45", property_percentage_owned: 100)).to be_valid
  end
end
