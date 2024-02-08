require "rails_helper"

RSpec.describe Steps::Logic::Thing do
  describe "#employed?" do
    it "returns false if the client is asylum supported" do
      session_data = {
        "employment_status" => "in_work",
        "asylum_support" => true,
        "immigration_or_asylum_type_upper_tribunal" => "immigration_upper",
      }

      expect(described_class.new(session_data).employed?).to eq false
    end
  end

  describe "#benefits?" do
    it "returns false if the client is passported" do
      session_data = {
        "passporting" => true,
        "receives_benefits" => true,
      }

      expect(described_class.new(session_data).benefits?).to eq false
    end
  end

  describe "#partner_owns_additional_property?" do
    it "returns false if the client has no partner" do
      session_data = {
        "partner" => false,
      }

      expect(described_class.new(session_data).partner_owns_additional_property?).to eq false
    end
  end

  describe "#partner_employed?" do
    it "returns false if the client has no partner" do
      session_data = {
        "partner" => false,
        "partner_employment_status" => "in_work",
      }

      expect(described_class.new(session_data).partner_employed?).to eq false
    end
  end

  describe "#partner_benefits?" do
    it "returns false if the client is passported" do
      session_data = {
        "passporting" => true,
        "partner_receives_benefits" => true,
      }

      expect(described_class.new(session_data).partner_benefits?).to eq false
    end
  end

  describe "#dependants?" do
    it "returns false if the client is passported" do
      session_data = {
        "passporting" => true,
        "partner_receives_benefits" => true,
      }

      expect(described_class.new(session_data).dependants?).to eq false
    end
  end

  describe "#dependants_get_income?" do
    it "returns false if the client is passported" do
      session_data = {
        "passporting" => true,
        "partner_receives_benefits" => true,
      }

      expect(described_class.new(session_data).dependants_get_income?).to eq false
    end
  end
end
