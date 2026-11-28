require "rails_helper"

RSpec.describe "standalone page title", type: :request do
  it "keeps the standard service title outside embedded mode" do
    get "/start"

    expect(Nokogiri::HTML(response.body).at_css("title").text).to eq("Check if your client qualifies for legal aid | GOV.UK")
  end
end
