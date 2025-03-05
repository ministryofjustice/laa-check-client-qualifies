require "rails_helper"

RSpec.describe SharedOwnershipHousingCostsForm do
  let(:form) { described_class.new(attributes, Check.new) }

  let(:base_attributes) do
    {
      shared_ownership_mortgage: 0,
      mortgage_frequency: nil,
      rent: 0,
      rent_frequency: nil,
      housing_benefit_relevant: false,
    }
  end

  context "when form is submitted and" do
    context "when mortgage is positive" do
      let(:attributes) { base_attributes.merge(shared_ownership_mortgage: 500, mortgage_frequency: "monthly") }

      it "is valid with a valid frequency" do
        expect(form).to be_valid
      end

      it "is invalid without a frequency" do
        attributes[:mortgage_frequency] = nil
        expect(form).not_to be_valid
        expect(form.errors.messages[:mortgage_frequency]).to include("Select frequency of mortgage payments.")
      end
    end

    context "when mortgage is zero" do
      let(:attributes) { base_attributes }

      it "is valid without a frequency" do
        expect(form).to be_valid
      end
    end

    context "when rent is positive" do
      let(:attributes) { base_attributes.merge(rent: 700, rent_frequency: "monthly") }

      it "is valid with a valid frequency" do
        expect(form).to be_valid
      end

      it "is invalid without a frequency" do
        attributes[:rent_frequency] = nil
        expect(form).not_to be_valid
        expect(form.errors.messages[:rent_frequency]).to include("Select frequency of rent payments.")
      end
    end

    context "when rent is zero" do
      let(:attributes) do
        {
          shared_ownership_mortgage: 500,
          mortgage_frequency: "monthly",
          rent_frequency: nil,
          housing_benefit_relevant: false,
          rent: 0,
        }
      end

      it "is valid without a frequency" do
        expect(form).to be_valid
      end
    end
  end

  describe "#housing_payment_frequencies" do
    let(:attributes) { base_attributes.merge(shared_ownership_mortgage: 500, mortgage_frequency: "monthly") }

    it "returns a mapped list of valid frequencies" do
      expect(form.housing_payment_frequencies).to eq(
        OutgoingsForm::VALID_FREQUENCIES.map { [_1, I18n.t("question_flow.outgoings.frequencies.#{_1}")] },
      )
    end
  end

  describe "#total_annual_housing_costs" do
    before do
      allow(form).to receive(:annual_multiplier).with("monthly").and_return(12)
      allow(form).to receive(:annual_multiplier).with("weekly").and_return(52)
      allow(form).to receive(:total_annual_housing_costs).and_call_original
    end

    context "when mortgage and rent are present with frequencies" do
      let(:attributes) { base_attributes.merge(shared_ownership_mortgage: 500, mortgage_frequency: "monthly", rent: 700, rent_frequency: "weekly") }

      it "calculates the total correctly" do
        expect(form.send(:total_annual_housing_costs)).to eq((500 * 12) + (700 * 52))
      end
    end

    context "when only mortgage is present with frequency" do
      let(:attributes) { base_attributes.merge(shared_ownership_mortgage: 500, mortgage_frequency: "monthly") }

      it "calculates the total correctly" do
        expect(form.send(:total_annual_housing_costs)).to eq(500 * 12)
      end
    end

    context "when only rent is present with frequency" do
      let(:attributes) { base_attributes.merge(rent: 700, rent_frequency: "weekly") }

      it "calculates the total correctly" do
        expect(form.send(:total_annual_housing_costs)).to eq(700 * 52)
      end
    end

    context "when neither mortgage nor rent have frequencies" do
      let(:attributes) { base_attributes }

      it "returns zero" do
        allow(form).to receive(:total_annual_housing_costs).and_call_original
        expect(form.send(:total_annual_housing_costs)).to eq(0)
      end
    end
  end
end
