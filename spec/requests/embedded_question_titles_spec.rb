require "rails_helper"

RSpec.describe "embedded question page titles", :embedded_only, ccq_mode: :embedded, type: :request do
  let(:resource_id) { "test_resource_id" }
  let(:question_path) { "/cases/#{resource_id}/eligibility/client-age-group" }
  let(:journey_store) { instance_double(JourneyDataStore::RedisStore, read: {}, write: nil) }

  before do
    allow(ModeConfig).to receive(:embedded_layout).and_return("rcw/application")
    allow(JourneyDataStore::RedisStore).to receive(:new).and_return(journey_store)
    I18n.backend.store_translations(:en, layouts: { rcw: { service: { homepage_url: "/" } } })
  end

  def document_title
    Nokogiri::HTML(response.body).at_css("title").text
  end

  it "titles an ordinary question page in the embedded format" do
    get question_path

    expect(document_title).to eq("What age is your client? - Record controlled work - GOV.UK")
  end

  describe "shared ownership housing costs" do
    let(:shared_ownership_path) { "/cases/#{resource_id}/eligibility/shared-ownership-housing-costs" }

    before do
      allow(journey_store).to receive(:read).and_return(
        "dependants" => true, "immigration_or_asylum" => false, "domestic_abuse_applicant" => false,
        "controlled_legal_representation" => false, "level_of_help" => "controlled", "partner" => false
      )
    end

    it "titles the page distinctly from housing costs" do
      get shared_ownership_path

      expect(document_title).to eq("Shared ownership housing costs - Record controlled work - GOV.UK")
    end
  end

  describe "partner benefit details" do
    let(:partner_benefit_path) { "/cases/#{resource_id}/eligibility/partner-benefit-details" }

    before do
      allow(CfeConnection).to receive(:state_benefit_types).and_return([])
      allow(journey_store).to receive(:read).and_return(
        "dependants" => true, "immigration_or_asylum" => false, "domestic_abuse_applicant" => false,
        "controlled_legal_representation" => false, "level_of_help" => "controlled", "partner" => true
      )
    end

    it "qualifies the title so it differs from the client benefit details page" do
      get partner_benefit_path

      expect(document_title).to eq("Add partner benefit details - Record controlled work - GOV.UK")
    end
  end

  it "prefixes the title with Error when the answer fails validation" do
    put question_path, params: { client_age_form: { client_age: "invalid" } }

    expect(response).to have_http_status(:ok)
    expect(document_title).to eq("Error: What age is your client? - Record controlled work - GOV.UK")
  end
end
