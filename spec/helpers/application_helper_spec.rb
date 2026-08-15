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

  describe "#back_link" do
    it "links to the previous step when one is given" do
      allow(helper).to receive(:params).and_return(assessment_code: "abc123")

      link = helper.back_link(:income, false)

      expect(link).to include("href=\"#{helper.step_path_from_step(:income, 'abc123')}\"")
    end

    context "when there is no previous step" do
      it "links to root_path in standalone mode" do
        allow(ModeConfig).to receive(:embedded?).and_return(false)
        allow(helper).to receive(:params).and_return({})

        link = helper.back_link(nil, false)

        expect(link).to include("href=\"#{helper.root_path}\"")
      end

      it "links to the RCW task list in embedded mode" do
        allow(ModeConfig).to receive(:embedded?).and_return(true)
        allow(helper).to receive(:params).and_return(resource_id: "case-123")

        link = helper.back_link(nil, false)

        expect(link).to include('href="/cases/case-123/task-list"')
      end
    end
  end
end
