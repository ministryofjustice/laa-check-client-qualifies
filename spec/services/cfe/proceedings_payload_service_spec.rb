require "rails_helper"

RSpec.describe Cfe::ProceedingsPayloadService do
  let(:service) { described_class }
  let(:payload) { {} }

  describe ".call" do
    context "when checking a certificated case" do
      let(:session_data) do
        {
          "level_of_help" => "certificated",
          "domestic_abuse_applicant" => false,
          "immigration_or_asylum_type_upper_tribunal" => "none",
        }
      end
      let(:relevant_steps) { %i[level_of_help domestic_abuse_applicant] }

      it "uses the relevant proceeding type" do
        service.call(session_data, payload, relevant_steps)
        expect(payload[:proceeding_types]).to eq(
          [{
            ccms_code: "SE003",
            client_involvement_type: "A",
          }],
        )
      end
    end

    context "when checking a certificated, asylum case" do
      let(:session_data) do
        {
          "level_of_help" => "certificated",
          "domestic_abuse_applicant" => false,
          "immigration_or_asylum_type_upper_tribunal" => "asylum_upper",
        }
      end
      let(:relevant_steps) { %i[level_of_help domestic_abuse_applicant immigration_or_asylum] }

      it "uses the relevant proceeding type" do
        service.call(session_data, payload, relevant_steps)
        expect(payload[:proceeding_types]).to eq(
          [{
            ccms_code: "IA031",
            client_involvement_type: "A",
          }],
        )
      end
    end

    context "when checking a certificated, immigration case" do
      let(:session_data) do
        {
          "level_of_help" => "certificated",
          "domestic_abuse_applicant" => false,
          "immigration_or_asylum_type_upper_tribunal" => "immigration_upper",
        }
      end
      let(:relevant_steps) { %i[level_of_help domestic_abuse_applicant immigration_or_asylum] }

      it "uses the relevant proceeding type" do
        service.call(session_data, payload, relevant_steps)
        expect(payload[:proceeding_types]).to eq(
          [{
            ccms_code: "IM030",
            client_involvement_type: "A",
          }],
        )
      end
    end

    context "when checking a certificated, domestic abuse case" do
      let(:session_data) do
        {
          "level_of_help" => "certificated",
          "domestic_abuse_applicant" => true,
        }
      end
      let(:relevant_steps) { %i[level_of_help domestic_abuse_applicant] }

      it "uses the relevant proceeding type" do
        service.call(session_data, payload, relevant_steps)
        expect(payload[:proceeding_types]).to eq(
          [{
            ccms_code: "DA001",
            client_involvement_type: "A",
          }],
        )
      end
    end

    context "when checking a controlled non-immigration/asylum case" do
      let(:session_data) do
        {
          "level_of_help" => "controlled",
          "immigration_or_asylum" => false,
        }
      end
      let(:relevant_steps) { %i[level_of_help immigration_or_asylum] }

      it "uses the 'other' proceeding type" do
        service.call(session_data, payload, relevant_steps)
        expect(payload[:proceeding_types]).to eq(
          [{
            ccms_code: "SE003",
            client_involvement_type: "A",
          }],
        )
      end
    end

    context "when checking a controlled immigration/asylum case" do
      let(:session_data) do
        {
          "level_of_help" => "controlled",
          "immigration_or_asylum" => true,
          "immigration_or_asylum_type" => immigration_or_asylum_type,
        }
      end
      let(:relevant_steps) { %i[level_of_help immigration_or_asylum] }

      context "when immigration or asylum type is CLR" do
        let(:immigration_or_asylum_type) { "immigration_clr" }

        it "uses the 'immigration' proceeding type" do
          service.call(session_data, payload, relevant_steps)
          expect(payload[:proceeding_types]).to eq(
            [{
              ccms_code: "IM030",
              client_involvement_type: "A",
            }],
          )
        end
      end

      context "when immigration or asylum type is legal help" do
        let(:immigration_or_asylum_type) { "immigration_legal_help" }

        it "uses the 'immigration' proceeding type" do
          service.call(session_data, payload, relevant_steps)
          expect(payload[:proceeding_types]).to eq(
            [{
              ccms_code: "IA031",
              client_involvement_type: "A",
            }],
          )
        end
      end

      context "when immigration or asylum type is asylum" do
        let(:immigration_or_asylum_type) { "asylum" }

        it "uses the 'immigration' proceeding type" do
          service.call(session_data, payload, relevant_steps)
          expect(payload[:proceeding_types]).to eq(
            [{
              ccms_code: "IA031",
              client_involvement_type: "A",
            }],
          )
        end
      end
    end
  end
end
