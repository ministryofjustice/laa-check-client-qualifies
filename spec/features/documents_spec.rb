require "rails_helper"

RSpec.describe "Documents" do
  scenario "I view a document with no section specified" do
    visit "/documents/lc_guidance_certificated"
    expect(page.find("body")["data-page-number"]).to eq "1"
    expect(page.find("body")["data-pdf-path"]).to eq "/documents/lc_guidance_certificated/download"
    expect(AnalyticsEvent.first.page).to eq "document_lc_guidance_certificated"
  end

  scenario "I view a document with a section specified" do
    visit "/documents/lc_guidance_certificated?sub_section=smod"
    expect(page.find("body")["data-page-number"]).to eq "8"
    expect(page.find("body")["data-pdf-path"]).to eq "/documents/lc_guidance_certificated/download"
    expect(AnalyticsEvent.first.page).to eq "document_lc_guidance_certificated_smod_section"
  end

  scenario "I download a document" do
    stub = stub_request(:get, "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1175064/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work__July_2023_.pdf")
    visit "/documents/lc_guidance_certificated"
    click_on "Download PDF"
    expect(page.response_headers["Content-Type"]).to eq("application/pdf")
    expect(stub).to have_been_requested
  end
end
