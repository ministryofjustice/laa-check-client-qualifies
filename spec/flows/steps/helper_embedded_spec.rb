require "rails_helper"

RSpec.describe Steps::Helper, :embedded_only, ccq_mode: :embedded do
  describe ".skip_step_in_embedded?" do
    it "does not skip steps outside embedded mode" do
      allow(ModeConfig).to receive(:embedded?).and_return(false)

      expect(described_class.skip_step_in_embedded?(:client_age, {
        "client_age" => ClientAgeForm::STANDARD,
      })).to be(false)
    end

    it "skips unconditional embedded steps" do
      expect(described_class.skip_step_in_embedded?(:level_of_help, {})).to be(true)
      expect(described_class.skip_step_in_embedded?(:immigration_or_asylum, {})).to be(true)
    end

    it "skips client age when it has a valid hydrated value" do
      expect(described_class.skip_step_in_embedded?(:client_age, {
        "client_age" => ClientAgeForm::STANDARD,
      })).to be(true)
    end

    it "does not skip client age when its value is missing or invalid" do
      expect(described_class.skip_step_in_embedded?(:client_age, {})).to be(false)
      expect(described_class.skip_step_in_embedded?(:client_age, {
        "client_age" => "invalid",
      })).to be(false)
    end
  end
end
