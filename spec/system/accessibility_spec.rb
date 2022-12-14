require "rails_helper"

RSpec.describe "Accessibility" do
  before { driven_by(:headless_chrome) }

  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }

  describe "accessibility statement" do
    before do
      visit accessibility_path
      click_on "Reject additional cookies"
      click_on "Hide cookie message"
    end

    it "has a clean accessibility page" do
      expect(page).to be_axe_clean
    end
  end

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

  describe "Privacy page" do
    before do
      visit privacy_path
    end

    it "has no AXE-detectable accessibility issues" do
      expect(page).to be_axe_clean
    end
  end

  describe "Estimate steps" do
    let(:estimate_id) { SecureRandom.uuid }

    before do
      travel_to arbitrary_fixed_time
    end

    StepsHelper.all_possible_steps.each do |step|
      it "has no AXE-detectable accessibility issues on #{step} step" do
        visit estimate_build_estimate_path(estimate_id, step)

        # govuk components deliberately break ARIA rules by putting 'aria-expanded' attributes on inputs
        # C.F. https://github.com/alphagov/govuk-frontend/issues/979
        expect(page).to be_axe_clean.skipping("aria-allowed-attr")
      end
    end
  end

  describe "Results page" do
    let(:estimate_id) { SecureRandom.uuid }
    let(:mock_connection) do
      instance_double(CfeConnection, create_applicant: nil,
                                     api_result: CalculationResult.new(build(:api_result)))
    end

    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      allow(mock_connection).to receive(:create_assessment_id)
      allow(mock_connection).to receive(:create_proceeding_type)
      allow(mock_connection).to receive(:create_regular_payments)
      visit_check_answers(passporting: true)
      click_on "Submit"
    end

    it "has no AXE-detectable accessibility issues" do
      expect(page).to be_axe_clean
    end
  end

  describe "Print results page" do
    let(:estimate_id) { SecureRandom.uuid }

    before do
      travel_to arbitrary_fixed_time
      allow(CfeService).to receive(:call).and_return(CalculationResult.new(build(:api_result)))
      visit check_answers_estimate_path estimate_id
      click_on "Submit"
      click_on "Print this page"
    end

    it "has no AXE-detectable accessibility issues" do
      expect(page).to be_axe_clean
    end
  end
end
