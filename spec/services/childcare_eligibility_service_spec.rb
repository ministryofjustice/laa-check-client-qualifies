require "rails_helper"

RSpec.describe ChildcareEligibilityService do
  let(:check) { Check.new(session) }

  context "when the self employed flag is disabled" do
    context "when the client is single, with child dependants" do
      let(:session) do
        {
          "child_dependants" => true,
          "partner" => false,
          "employment_status" => employment_status,
          "student_finance_value" => 0,
        }
      end

      context "when the client is in work" do
        let(:employment_status) { "in_work" }

        it "returns true" do
          expect(described_class.call(check)).to eq true
        end
      end

      context "when the client is unemployed" do
        let(:employment_status) { "unemployed" }

        it "returns false" do
          expect(described_class.call(check)).to eq false
        end
      end

      context "when the client is on statutory pay" do
        let(:employment_status) { "receiving_statutory_pay" }

        it "returns false" do
          expect(described_class.call(check)).to eq false
        end
      end
    end
  end

  context "when the self employed flag is enabled", :self_employed_flag do
    context "when the client is single and working with child dependants" do
      let(:session) do
        {
          "child_dependants" => true,
          "partner" => false,
          "employment_status" => "in_work",
          "incomes" => [{
            "income_type" => income_type,
          }],
          "student_finance_value" => 0,
        }
      end

      context "when the client is employed" do
        let(:income_type) { "employment" }

        it "returns true" do
          expect(described_class.call(check)).to eq true
        end
      end

      context "when the client is self-employed" do
        let(:income_type) { "self_employment" }

        it "returns true" do
          expect(described_class.call(check)).to eq true
        end
      end

      context "when the client on statutory pay" do
        let(:income_type) { "statutory_pay" }

        it "returns false" do
          expect(described_class.call(check)).to eq false
        end
      end
    end

    context "when the client is single and a student with child dependants" do
      let(:session) do
        {
          "child_dependants" => true,
          "partner" => false,
          "employment_status" => "unemployed",
          "student_finance_value" => 1,
        }
      end

      it "returns true" do
        expect(described_class.call(check)).to eq true
      end
    end

    context "when the client is single, unemployed and not a student, with child dependants" do
      let(:session) do
        {
          "child_dependants" => true,
          "partner" => false,
          "employment_status" => "unemployed",
          "student_finance_value" => 0,
        }
      end

      it "returns false" do
        expect(described_class.call(check)).to eq false
      end
    end

    context "when the client is single, a student, with no child dependants" do
      let(:session) do
        {
          "child_dependants" => false,
          "partner" => false,
          "employment_status" => "unemployed",
          "student_finance_value" => 1,
        }
      end

      it "returns false" do
        expect(described_class.call(check)).to eq false
      end
    end

    context "when the client is eligible but the partner is not" do
      let(:session) do
        {
          "child_dependants" => true,
          "partner" => true,
          "student_finance_value" => 1,
          "partner_employment_status" => "unemployed",
          "partner_student_finance_value" => 0,
        }
      end

      it "returns false" do
        expect(described_class.call(check)).to eq false
      end
    end

    context "when the client is eligible and the partner is a student" do
      let(:session) do
        {
          "child_dependants" => true,
          "partner" => true,
          "student_finance_value" => 1,
          "partner_employment_status" => "unemployed",
          "partner_student_finance_value" => 1,
        }
      end

      it "returns true" do
        expect(described_class.call(check)).to eq true
      end
    end

    context "when the client is eligible and the partner is in work" do
      let(:session) do
        {
          "child_dependants" => true,
          "partner" => true,
          "student_finance_value" => 1,
          "partner_employment_status" => "in_work",
          "partner_incomes" => [{
            "income_type" => "employment",
          }],
          "partner_student_finance_value" => 0,
        }
      end

      it "returns true" do
        expect(described_class.call(check)).to eq true
      end
    end
  end
end
