require "rails_helper"

RSpec.describe "IntroPage" do
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
  end

  # have to skip aria-allowed-attr for govuk conditional radio buttons.
  it "has no AXE-detectable accessibility issues" do
    visit "/estimates/new"
    expect(page).to be_axe_clean.skipping("aria-allowed-attr")
  end
end
