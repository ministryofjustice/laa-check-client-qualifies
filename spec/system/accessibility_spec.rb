require "rails_helper"

RSpec.describe "Accessibility" do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }

  describe "Start page" do
    before do
      visit root_path
    end

    it "has no AXE-detectable accessibility issues" do
      expect(page).to be_axe_clean
    end
  end

  describe "Legal aid provider check" do
    before do
      visit root_path
      click_on "Start now"
    end

    it "has no AXE-detectable accessibility issues" do
      expect(page).to be_axe_clean
    end
  end

  describe "Referrals page" do
    before do
      visit referrals_path
    end

    it "has no AXE-detectable accessibility issues" do
      expect(page).to be_axe_clean
    end
  end

  describe "Cookies page" do
    before do
      visit cookies_path
    end

    it "has no AXE-detectable accessibility issues" do
      expect(page).to be_axe_clean
    end
  end

  describe "Estimate steps" do
    let(:estimate_id) { SecureRandom.uuid }
    let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id, api_result: {}) }

    before do
      travel_to arbitrary_fixed_time
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    StepsHelper::STEPS_WITH_PROPERTY.each do |step|
      it "has no AXE-detectable accessibility issues on #{step} step" do
        visit estimate_build_estimate_path(estimate_id, step)

        # govuk components deliberately break ARIA rules by putting 'aria-expanded' attributes on inputs
        # C.F. https://github.com/alphagov/govuk-frontend/issues/979
        expect(page).to be_axe_clean.skipping("aria-allowed-attr")
      end
    end
  end
end
