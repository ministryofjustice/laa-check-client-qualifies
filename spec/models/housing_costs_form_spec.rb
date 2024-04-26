require "rails_helper"

RSpec.describe HousingCostsForm do
  let(:form) do
    described_class.new(attributes, Check.new)
  end

  context "with no data" do
    let(:attributes) { {} }

    context "without conditional reveals", :legacy_housing_benefit_without_reveals do
      it "errors" do
        expect(form).not_to be_valid
        expect(form.errors.messages)
          .to eq(
            {
              housing_benefit_value: ["Enter the Housing Benefit amount. Enter 0 if this does not apply."],
              housing_payments: ["Enter the housing payments amount. Enter 0 if this does not apply."],
            },
          )
      end
    end

    context "with conditional reveals" do
      it "errors" do
        expect(form).not_to be_valid
        expect(form.errors.messages)
          .to eq(
            {
              housing_benefit_relevant: ["Select yes if housing benefit is claimed at the home your client lives in"],
              housing_payments: ["Enter the housing payments amount. Enter 0 if this does not apply."],
            },
          )
      end
    end
  end

  context "with zero benefits" do
    context "without conditional reveals", :legacy_housing_benefit_without_reveals do
      let(:attributes) { { housing_payments: 0, housing_benefit_value: 0 } }

      it "doesnt error" do
        expect(form).to be_valid
      end
    end

    context "with conditional reveals" do
      context "when relevant" do
        let(:attributes) { { housing_payments: 0, housing_benefit_relevant: true, housing_benefit_value: 0 } }

        it "errors" do
          expect(form).not_to be_valid
          expect(form.errors.messages)
            .to eq(
              {
                housing_benefit_frequency: ["Select frequency of Housing Benefit."],
                housing_benefit_value: ["Housing Benefit must be more than 0"],
              },
            )
        end
      end

      context "when not relevant" do
        let(:attributes) { { housing_payments: 0, housing_benefit_relevant: false, housing_benefit_value: 0 } }

        it "is valid" do
          expect(form).to be_valid
        end
      end
    end
  end

  context "with negative benefits" do
    context "without conditional reveals", :legacy_housing_benefit_without_reveals do
      let(:attributes) { { housing_payments: 0, housing_benefit_frequency: "monthly", housing_benefit_value: -1 } }

      it "errors" do
        expect(form).not_to be_valid
        expect(form.errors.messages)
          .to eq({ housing_benefit_value: ["Housing Benefit must be must be 0 or more"] })
      end
    end

    context "with conditional reveals" do
      context "when relevant" do
        let(:attributes) { { housing_payments: 0, housing_benefit_relevant: true, housing_benefit_value: -1 } }

        it "errors" do
          expect(form).not_to be_valid
          expect(form.errors.messages)
            .to eq(
              {
                housing_benefit_frequency: ["Select frequency of Housing Benefit."],
                housing_benefit_value: ["Housing Benefit must be more than 0"],
              },
            )
        end
      end

      context "when not relevant" do
        let(:attributes) { { housing_payments: 0, housing_benefit_relevant: false, housing_benefit_value: -1 } }

        it "is valid" do
          expect(form).to be_valid
        end
      end
    end
  end

  context "when benefits exceeds costs" do
    context "without conditional reveals", :legacy_housing_benefit_without_reveals do
      let(:attributes) { { housing_payments: 34, housing_payments_frequency: "every_week", housing_benefit_frequency: "every_week", housing_benefit_value: 45 } }

      it "detects if benefit exceeds costs" do
        expect(form).not_to be_valid
        expect(form.errors.messages)
          .to eq(
            { housing_benefit_value: ["Housing Benefit cannot be higher than housing costs"] },
          )
      end
    end

    context "with conditional reveals" do
      context "when relevant" do
        let(:attributes) do
          { housing_payments: 34,
            housing_payments_frequency: "every_week",
            housing_benefit_relevant: true,
            housing_benefit_frequency: "every_week",
            housing_benefit_value: 45 }
        end

        it "detects if benefit exceeds costs" do
          expect(form).not_to be_valid
          expect(form.errors.messages)
            .to eq(
              { housing_benefit_value: ["Housing Benefit cannot be higher than housing costs"] },
            )
        end
      end

      context "when not relevant" do
        let(:attributes) do
          { housing_payments: 34,
            housing_payments_frequency: "monthly",
            housing_benefit_relevant: false,
            housing_benefit_frequency: "monthly",
            housing_benefit_value: 45 }
        end

        it "is valid" do
          expect(form).to be_valid
        end
      end
    end
  end

  context "with benefits but zero costs" do
    context "without conditional reveals", :legacy_housing_benefit_without_reveals do
      let(:attributes) { { housing_payments: 0, housing_benefit_frequency: "every_week", housing_benefit_value: 45 } }

      it "detects if benefit exceeds costs" do
        expect(form).not_to be_valid
        expect(form.errors.messages)
          .to eq({ housing_benefit_value: ["Housing Benefit cannot be higher than housing costs"] })
      end
    end

    context "with conditional reveals" do
      context "when relevant" do
        let(:attributes) do
          { housing_payments: 0,
            housing_benefit_relevant: true,
            housing_benefit_frequency: "every_week",
            housing_benefit_value: 45 }
        end

        it "detects if benefit exceeds costs" do
          expect(form).not_to be_valid
          expect(form.errors.messages)
            .to eq({ housing_benefit_value: ["Housing Benefit cannot be higher than housing costs"] })
        end
      end

      context "when not relevant" do
        let(:attributes) do
          { housing_payments: 0,
            housing_payments_frequency: "monthly",
            housing_benefit_relevant: false,
            housing_benefit_frequency: "monthly",
            housing_benefit_value: 45 }
        end

        it "is valid" do
          expect(form).to be_valid
        end
      end
    end
  end

  context "without payment frequency" do
    context "without conditional reveals", :legacy_housing_benefit_without_reveals do
      let(:attributes) { { housing_payments: 34, housing_benefit_frequency: "monthly", housing_benefit_value: 23 } }

      it "errors correctly" do
        expect(form).not_to be_valid
        expect(form.errors.messages)
          .to eq({ housing_payments_frequency: ["Select frequency of housing payments."] })
      end
    end

    context "with conditional reveals" do
      let(:attributes) do
        { housing_payments: 34,
          housing_benefit_relevant: true,
          housing_benefit_frequency: "monthly",
          housing_benefit_value: 23 }
      end

      it "errors correctly" do
        expect(form).not_to be_valid
        expect(form.errors.messages)
          .to eq({ housing_payments_frequency: ["Select frequency of housing payments."] })
      end
    end
  end
end
