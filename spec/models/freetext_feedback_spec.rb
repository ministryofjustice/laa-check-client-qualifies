require "rails_helper"

RSpec.describe FreetextFeedback, type: :model do
  describe "validations" do
    context "when text is nil" do
      let(:model) { described_class.new(text: nil, page: "some page") }

      it "throws error when text is blank" do
        expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when text is blank" do
      let(:model) { described_class.new(text: "", page: "some page") }

      it "throws error when text is blank" do
        expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when page is nil" do
      let(:model) { described_class.new(text: "text", page: nil) }

      it "throws error when page is blank" do
        expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  it "saves successfully" do
    described_class.new(text: "text", level_of_help: nil, page: "some page").save!
    expect(described_class.all.count).to be(1)
  end
end
