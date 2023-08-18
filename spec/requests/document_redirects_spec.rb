require "rails_helper"

RSpec.describe "external redirects" do
  let(:response_json) { JSON.parse(response.body) }

  describe "GET /documents" do
    it "redirects non-pdf documents" do
      get("/documents/legislation_CLAR_2013")
      expect(response.headers["location"]).to eq "https://www.legislation.gov.uk/uksi/2013/480/contents"
      expect(AnalyticsEvent.first.page).to eq "document_legislation_CLAR_2013"
    end
  end
end
