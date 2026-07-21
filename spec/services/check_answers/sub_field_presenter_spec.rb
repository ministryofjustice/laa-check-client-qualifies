require "rails_helper"

RSpec.describe CheckAnswers::SubFieldPresenter do
  describe "#screen and #disputed?" do
    it "returns nil for both optional fields" do
      model = Struct.new(:income_type).new("employment")
      presenter = described_class.new(
        table_label: :employment,
        attribute: :income_type,
        type: :select,
        model:,
      )

      expect(presenter.screen).to be_nil
      expect(presenter.disputed?).to be_nil
    end
  end
end
