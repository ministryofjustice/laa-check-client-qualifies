require "rails_helper"

RSpec.describe CheckAnswers::SectionIdFinder do
  it "returns a value for every step", :partner_flag do
    Steps::Helper.all_possible_steps.each do |step|
      expect(described_class.call(step)).to be_present
    end
  end
end
