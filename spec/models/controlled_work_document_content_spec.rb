require "rails_helper"

RSpec.describe ControlledWorkDocumentContent do
  describe "#from_cfe_payload" do
    it "can handle paths with numbers in them" do
      session_data = {
        "api_response" => {
          "foo" => [
            { "bar" => 0 },
            { "bar" => 56 },
            { "bar" => 0 },
          ],
        },
      }
      expect(described_class.new(session_data).from_cfe_payload("foo.1.bar")).to eq "56"
    end
  end

  describe "#main_home_percentage_owned" do
    it "takes into account partner percentage owned" do
      session_data = {
        "property_owned" => "outright",
        "partner" => true,
        "joint_ownership" => true,
        "percentage_owned" => 53,
        "joint_percentage_owned" => 25,
      }
      expect(described_class.new(session_data).from_attribute(:main_home_percentage_owned)).to eq "78"
    end
  end

  describe "#additional_non_smod_properties_percentage_owned" do
    def make_capital(percentage_owned)
      {
        "capital_items" => {
          "properties" => {
            "additional_properties" => [
              { "percentage_owned" => percentage_owned },
            ],
          },
        },
      }
    end

    it "returns the percentage owned if it's always the same" do
      session_data = {
        "api_response" => {
          "assessment" => {
            "capital" => make_capital(50),
            "partner_capital" => make_capital(50),
          },
        },
      }
      expect(described_class.new(session_data).from_attribute(:additional_non_smod_properties_percentage_owned)).to eq "50"
    end

    it "returns 'unknown' if it differs" do
      session_data = {
        "api_response" => {
          "assessment" => {
            "capital" => make_capital(50),
            "partner_capital" => make_capital(51),
          },
        },
      }
      expect(described_class.new(session_data).from_attribute(:additional_non_smod_properties_percentage_owned)).to eq "Unknown"
    end

    it "ignores client capital if client additional home is SMOD" do
      session_data = {
        "in_dispute" => %w[property],
        "api_response" => {
          "assessment" => {
            "capital" => make_capital(50),
            "partner_capital" => make_capital(51),
          },
        },
      }
      expect(described_class.new(session_data).from_attribute(:additional_non_smod_properties_percentage_owned)).to eq "51"
    end
  end

  context "when the main home is owned" do
    let(:session_data) do
      {
        "property_owned" => "outright",
        "partner" => true,
        "joint_ownership" => false,
        "percentage_owned" => 100,
        "api_response" => {
          "result_summary" => {
            "disposable_income" => {
              "net_housing_costs" => 43.2,
            },
            "partner_disposable_income" => {
              "net_housing_costs" => 44,
            },
          },
        },
      }
    end

    describe "#client_mortgage" do
      it "returns housing costs" do
        expect(described_class.new(session_data).from_attribute(:client_mortgage)).to eq "43.20"
      end
    end

    describe "#partner_mortgage" do
      it "returns housing costs" do
        expect(described_class.new(session_data).from_attribute(:partner_mortgage)).to eq "44"
      end
    end

    describe "#client_rent" do
      it "returns zero" do
        expect(described_class.new(session_data).from_attribute(:client_rent)).to eq "0"
      end
    end

    describe "#partner_rent" do
      it "returns zero" do
        expect(described_class.new(session_data).from_attribute(:partner_rent)).to eq "0"
      end
    end
  end

  context "when the main home is rented" do
    let(:session_data) do
      {
        "property_owned" => "nont",
        "partner" => true,
        "api_response" => {
          "result_summary" => {
            "disposable_income" => {
              "net_housing_costs" => 43.2,
            },
            "partner_disposable_income" => {
              "net_housing_costs" => 44,
            },
          },
        },
      }
    end

    describe "#client_mortgage" do
      it "returns zero" do
        expect(described_class.new(session_data).from_attribute(:client_mortgage)).to eq "0"
      end
    end

    describe "#partner_mortgage" do
      it "returns zero" do
        expect(described_class.new(session_data).from_attribute(:partner_mortgage)).to eq "0"
      end
    end

    describe "#client_rent" do
      it "returns housing costs" do
        expect(described_class.new(session_data).from_attribute(:client_rent)).to eq "43.20"
      end
    end

    describe "#partner_rent" do
      it "returns housing costs" do
        expect(described_class.new(session_data).from_attribute(:partner_rent)).to eq "44"
      end
    end
  end
end
