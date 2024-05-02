require "rails_helper"

RSpec.describe ClientAssetsForm do
  let(:form) do
    described_class.new(attributes, Check.new)
  end

  let(:blank_form) do
    { bank_accounts: [BankAccountModel.new(amount: 27)], investments_in_dispute: false, valuables_in_dispute: false }
  end

  context "with no data" do
    let(:attributes) { blank_form }

    context "without conditional reveals", :legacy_assets_no_reveal do
      it "errors" do
        expect(form).not_to be_valid
        expect(form.errors.messages)
          .to eq({
            investments: ["Enter the total value of investments. Enter 0 if this does not apply."],
            valuables: ["Enter the total value of items worth £500 or more. Enter 0 if this does not apply."],
          })
      end
    end

    context "with conditional reveals" do
      it "errors" do
        expect(form).not_to be_valid
        expect(form.errors.messages)
          .to eq(
            {
              investments_relevant: ["Select yes if client has any investments"],
              valuables_relevant: ["Select yes if client has any valuables worth more than £500"],
            },
          )
      end
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
    context "without conditional reveals", :legacy_assets_no_reveal do
      let(:attributes) { blank_form.merge(investments: 0, valuables: 0) }

      it "is valid" do
        expect(form).to be_valid
      end
    end

    context "with conditional reveals" do
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

  context "with 400 valuables" do
    context "without conditional reveals", :legacy_assets_no_reveal do
      let(:attributes) { blank_form.merge(investments: 0, valuables: 400) }

      it "errors" do
        expect(form).not_to be_valid
        expect(form.errors.messages)
          .to eq({ valuables: ["Valuable items must be £500 or more. Enter 0 if this does not apply."] })
      end
    end

    context "with conditional reveals" do
      let(:attributes) { blank_form.merge({ investments: 0, valuables: 400, investments_relevant: true, valuables_relevant: true }) }

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
end
