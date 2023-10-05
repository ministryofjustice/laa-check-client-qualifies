require "rails_helper"

RSpec.describe SatisfactionFeedback, type: :model do
  describe "validations" do
    context "when satisfied is invalid" do
      let(:model) { described_class.new(satisfied: "foo") }

      it "throws an error" do
        expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  it "saves successfully" do
    described_class.new(satisfied: "yes", level_of_help: "controlled", outcome: "eligible").save!
    expect(described_class.all.count).to be(1)
  end
end
