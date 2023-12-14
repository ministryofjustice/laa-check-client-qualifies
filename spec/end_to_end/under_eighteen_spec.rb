require "rails_helper"

RSpec.describe "Under-18 checks", :under_eighteen_flag do
  before do
    start_assessment
    fill_in_client_age_screen(choice: "Under 18")
  end

  describe "certificated check", type: :feature do
    before do
      fill_in_level_of_help_screen(choice: "Civil certificated")
    end

    context "with stubbing" do
      let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

      before { travel_to fixed_arbitrary_date }

      it "sends the right data to CFE for certificated work" do
        stubbed_assessment_call = stub_request(:post, %r{assessments\z}).with { |request|
          parsed = JSON.parse(request.body)
          expect(parsed["assessment"]).to eq({
            "submission_date" => "2023-02-15",
            "level_of_help" => "certificated",
          })
          expect(parsed["proceeding_types"]).not_to be_present
          expect(parsed["applicant"]).to eq({
            "date_of_birth" => "2006-02-15",
          })
        }.to_return(
          body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
          headers: { "Content-Type" => "application/json" },
        )

        click_on "Submit"
        expect(stubbed_assessment_call).to have_been_requested
      end
    end

    context "when hitting the API", :end2end do
      it "renders content" do
        click_on "Submit"
        expect(page).to have_content("Your client qualifies for civil legal aid without a means test, for certificated work")
        expect(page).not_to have_content("Income calculation")
        expect(page).not_to have_content("Outgoings calculation")
        expect(page).not_to have_content("Capital calculation")
      end
    end
  end

  describe "controlled legal representation check", type: :feature do
    before do
      fill_in_level_of_help_screen(choice: "Civil controlled")
      fill_in_under_18_controlled_legal_rep_screen(choice: "Yes")
    end

    context "with stubbing" do
      let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

      before { travel_to fixed_arbitrary_date }

      it "sends the right data to CFE for certificated work" do
        stubbed_assessment_call = stub_request(:post, %r{assessments\z}).with { |request|
          parsed = JSON.parse(request.body)
          expect(parsed["assessment"]).to eq({
            "submission_date" => "2023-02-15",
            "level_of_help" => "controlled",
            "controlled_legal_representation" => true,
          })
          expect(parsed["proceeding_types"]).not_to be_present
          expect(parsed["applicant"]).to eq({
            "date_of_birth" => "2006-02-15",
          })
        }.to_return(
          body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
          headers: { "Content-Type" => "application/json" },
        )

        click_on "Submit"
        expect(stubbed_assessment_call).to have_been_requested
      end
    end

    context "when hitting the API", :end2end do
      it "renders content" do
        click_on "Submit"
        expect(page).to have_content("Your client qualifies for civil legal aid without a means test, for controlled legal representation")
        expect(page).not_to have_content("Income calculation")
        expect(page).not_to have_content("Outgoings calculation")
        expect(page).not_to have_content("Capital calculation")
      end
    end
  end

  describe "non-means-tested controlled check", type: :feature do
    before do
      fill_in_level_of_help_screen(choice: "Civil controlled")
      fill_in_under_18_controlled_legal_rep_screen(choice: "No")
      fill_in_aggregated_means_screen(choice: "No")
      fill_in_regular_income_screen(choice: "No")
      fill_in_under_eighteen_assets_screen(choice: "No")
    end

    context "with stubbing" do
      let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

      before { travel_to fixed_arbitrary_date }

      it "sends the right data to CFE for certificated work" do
        stubbed_assessment_call = stub_request(:post, %r{assessments\z}).with { |request|
          parsed = JSON.parse(request.body)
          expect(parsed["assessment"]).to eq({
            "submission_date" => "2023-02-15",
            "level_of_help" => "controlled",
            "controlled_legal_representation" => false,
            "not_aggregated_no_income_low_capital" => true,
          })
          expect(parsed["proceeding_types"]).not_to be_present
          expect(parsed["applicant"]).to eq({
            "date_of_birth" => "2006-02-15",
          })
        }.to_return(
          body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
          headers: { "Content-Type" => "application/json" },
        )

        click_on "Submit"
        expect(stubbed_assessment_call).to have_been_requested
      end
    end

    context "when hitting the API", :end2end do
      it "renders content" do
        click_on "Submit"
        expect(page).to have_content("Your client qualifies for civil legal aid without a full means test, for controlled work and family mediation")
        expect(page).not_to have_content("Income calculation")
        expect(page).not_to have_content("Outgoings calculation")
        expect(page).not_to have_content("Capital calculation")
      end
    end
  end
end
