require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#as_money_string" do
    it "formats 100 as 100" do
      expect(helper.as_money_string(100)).to eq("100")
    end

    it "formats 120.1 as 120.10" do
      expect(helper.as_money_string(120.1)).to eq("120.10")
    end
  end
end
