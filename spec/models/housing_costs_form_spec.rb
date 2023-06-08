require "rails_helper"

RSpec.describe HousingCostsForm, type: :model do
  it "throws an error if the frequency is unrecognised" do
    subject = described_class.new(
      housing_payments: 1,
      housing_benefit_value: 1,
      housing_payments_frequency: "monthly",
      housing_benefit_frequency: "some unknown thing",
    )
    expect { subject.valid? }.to raise_error "Unrecognised frequency: some unknown thing"
  end
end
