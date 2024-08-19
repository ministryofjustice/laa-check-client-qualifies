require "rails_helper"

RSpec.describe PartnerAssetsForm do
  let(:feature_flags) { FeatureFlags.session_flags }
  let(:form) do
    described_class.new(attributes, Check.new({ "feature_flags" => feature_flags }))
  end

  let(:blank_form) do
    { bank_accounts: [BankAccountModel.new(amount: 27)] }
  end

  context "with no data" do
    let(:attributes) { blank_form }

    it "errors" do
      expect(form).not_to be_valid
      expect(form.errors.messages)
        .to eq(
          {
            investments_relevant: ["Select yes if the partner has any investments"],
            valuables_relevant: ["Select yes if the partner has any valuables worth more than £500"],
          },
        )
    end

    context "with relevancies on" do
      let(:attributes) { blank_form.merge({ investments_relevant: true, valuables_relevant: true }) }

      it "errors" do
        expect(form).not_to be_valid
        expect(form.errors.messages)
          .to eq(
            {
              investments: ["Enter the total value of investments."],
              valuables: ["Enter the total value of items worth £500 or more."],
            },
          )
      end
    end
  end

  context "with zero assets" do
    let(:attributes) { blank_form.merge({ investments: 0, valuables: 0, investments_relevant: true, valuables_relevant: true }) }

    it "errors" do
      expect(form).not_to be_valid
      expect(form.errors.messages)
        .to eq(
          { investments: ["The total value of all investments must be greater than 0."],
            valuables: ["Valuable items must be £500 or more."] },
        )
    end
  end
end
