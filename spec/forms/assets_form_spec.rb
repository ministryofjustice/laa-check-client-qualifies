require "rails_helper"

RSpec.describe AssetsForm, type: :model do
  it "allows a zero mortgage value" do
    expect(described_class.new(property_mortgage: 0, property_value: 45, property_percentage_owned: 100)).to be_valid
  end
end
