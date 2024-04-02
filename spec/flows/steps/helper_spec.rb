require "rails_helper"

RSpec.describe Steps::Helper do
  describe "#relevant_step?" do
    context "when there is asylum support data plus income data" do
      let(:session_data) do
        {
          "immigration_or_asylum_type_upper_tribunal" => "immigration_upper",
          "asylum_support" => true,
          "employment_status" => "in_work",
          "incomes" => [
            {
              "income_type" => "employment",
              "income_frequency" => "monthly",
              "gross_income" => 100,
              "income_tax" => 20,
              "national_insurance" => 3,
            },
          ],
        }
      end

      it "returns the correct relevant step" do
        expect(described_class.relevant_steps(session_data))
          .to eq(%i[client_age level_of_help domestic_abuse_applicant immigration_or_asylum_type_upper_tribunal asylum_support])
      end
    end

    context "when client is passported and there is income data" do
      let(:session_data) do
        {
          "partner" => false,
          "passporting" => true,
          "employment_status" => "in_work",
          "incomes" => [
            {
              "income_type" => "employment",
              "income_frequency" => "monthly",
              "gross_income" => 100,
              "income_tax" => 20,
              "national_insurance" => 3,
            },
          ],
        }
      end

      it "returns the correct relevant step" do
        expect(described_class.relevant_steps(session_data))
          .to eq(%i[client_age level_of_help domestic_abuse_applicant immigration_or_asylum_type_upper_tribunal applicant property additional_property assets vehicle])
      end
    end
  end
end
