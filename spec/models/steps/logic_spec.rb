require "rails_helper"

RSpec.describe Steps::Logic do
  describe "#employed?" do
    it "returns false if the client is asylum supported" do
      session_data = {
        "employment_status" => "in_work",
        "asylum_support" => true,
        "matter_type" => "immigration",
      }

      expect(described_class.employed?(session_data)).to eq false
    end
  end

  describe "#benefits?" do
    it "returns false if the client is passported" do
      session_data = {
        "passporting" => true,
        "receives_benefits" => true,
      }

      expect(described_class.benefits?(session_data)).to eq false
    end
  end

  describe "#partner_owns_additional_property?" do
    it "returns false if the client has no partner" do
      session_data = {
        "partner" => false,
      }

      expect(described_class.partner_owns_additional_property?(session_data)).to eq false
    end
  end

  describe "#partner_employed?" do
    it "returns false if the client has no partner" do
      session_data = {
        "partner" => false,
        "partner_employment_status" => "in_work",
      }

      expect(described_class.partner_employed?(session_data)).to eq false
    end
  end

  describe "#partner_benefits?" do
    it "returns false if the client is passported" do
      session_data = {
        "passporting" => true,
        "partner_receives_benefits" => true,
      }

      expect(described_class.partner_benefits?(session_data)).to eq false
    end
  end

  describe "#dependants?" do
    it "returns false if the client is passported" do
      session_data = {
        "passporting" => true,
        "partner_receives_benefits" => true,
      }

      expect(described_class.dependants?(session_data)).to eq false
    end
  end

  describe "#dependants_get_income?" do
    it "returns false if the client is passported" do
      session_data = {
        "passporting" => true,
        "partner_receives_benefits" => true,
      }

      expect(described_class.dependants_get_income?(session_data)).to eq false
    end
  end
end
