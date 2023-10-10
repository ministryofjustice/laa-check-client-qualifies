require "rails_helper"

RSpec.describe "Accessibility" do
  before { driven_by(:headless_chrome) }

  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }

  describe "accessibility statement" do
    before do
      visit accessibility_path
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

  describe "Error page" do
    before { visit "/500" }

    it "has no AXE-detectable accessibility issues" do
      expect(page).to be_axe_clean
    end
  end

  describe "Feature flags page" do
    before { visit "/feature-flags" }

    it "has no AXE-detectable accessibility issues" do
      expect(page).to be_axe_clean
    end
  end

  describe "Estimate steps" do
    before do
      travel_to arbitrary_fixed_time
      allow(CfeConnection).to receive(:state_benefit_types).and_return([])
    end

    %w[controlled certificated].each do |level_of_help|
      it "has no AXE-detectable accessibility issues on any page" do
        start_assessment
        fill_in_level_of_help_screen choice: level_of_help
        assessment_code = current_path.split("/").reverse.second

        Steps::Helper.all_possible_steps.each do |step|
          visit form_path(step, assessment_code)

          # govuk components deliberately break ARIA rules by putting 'aria-expanded' attributes on inputs
          # C.F. https://github.com/alphagov/govuk-frontend/issues/979
          expect(page).to be_axe_clean.skipping("aria-allowed-attr")
        end
      end
    end
  end

  describe "Results page" do
    let(:api_result) { build(:api_result) }

    before do
      allow(CfeService).to receive(:call).and_return(api_result)
      start_assessment
      fill_in_forms_until(:check_answers)
      click_on "Submit"
    end

    it "has no AXE-detectable accessibility issues" do
      # govuk accordions deliberately break ARIA rules by putting 'aria-labelledBy' without a role
      # C.F. https://github.com/alphagov/govuk-frontend/issues/2472#issuecomment-1398629391
      expect(page).to be_axe_clean.skipping("aria-prohibited-attr")
    end
  end
end
