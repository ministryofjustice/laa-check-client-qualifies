require "rails_helper"

RSpec.describe CheckAnswers::SectionIdFinder do
  it "returns a value for every non-household step" do
    Steps::Helper.all_steps_for_current_feature_flags.each do |step|
      expect(described_class.call(step)).to be_present
    end
  end

  context "when the household flow is enabled", :household_section_flag do
    it "returns a value for every household step" do
      Steps::Helper.all_steps_for_current_feature_flags.each do |step|
        expect(described_class.call(step)).to be_present
      end
    end
  end
end
