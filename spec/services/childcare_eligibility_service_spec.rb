require "rails_helper"

RSpec.describe ChildcareEligibilityService do
  let(:check) { Check.new(session) }

  context "when the client is single and working with child dependants" do
    let(:session) do
      {
        "child_dependants" => true,
        "partner" => false,
        "employment_status" => "in_work",
        "incomes" => [{
          "income_type" => income_type,
        }],
        "student_finance_relevant" => false,
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
        "student_finance_relevant" => true,
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
        "student_finance_relevant" => false,
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
        "student_finance_relevant" => true,
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
        "student_finance_relevant" => true,
        "partner_employment_status" => "unemployed",
        "partner_student_finance_relevant" => false,
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
        "student_finance_relevant" => true,
        "partner_employment_status" => "unemployed",
        "partner_student_finance_relevant" => true,
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
        "student_finance_relevant" => true,
        "partner_employment_status" => "in_work",
        "partner_incomes" => [{
          "income_type" => "employment",
        }],
        "partner_student_finance_relevant" => false,
      }
    end

    it "returns true" do
      expect(described_class.call(check)).to eq true
    end
  end
end
